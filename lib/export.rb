require "spree"

class Export
  def initialize root
    @root = root
  end
  def init_all
    init_products
    init_taxons
    init_orders
  end
  def passthrough object , attributes
    ret = {}
    attributes.each do |name|
      ret[name.to_s] = object.send(name)
    end
    ret
  end
  def init_orders
    @orders = {}
    @items = {}
    @baskets = {}
    @users = {}
    orders = Spree::Order.where(:state => "complete" )
    puts "orders #{orders.length}"
    orders.each do |order|
      att = passthrough( order , ["id" , "email" , "number" , "created_at"])
      att["ordered_on"] = order.completed_at
      add_user(order) if order.user and !order.user.email.index("example.net")
      add_basket(order)
      add_address(order , order.bill_address)
      @orders[order.id] = att
    end
  end
  def add_address object , address
    return unless address
    add = {}
    add["name"] = address.firstname + " " + address.lastname
    add["street"] = address.address1 + " " + address.address2.to_s
    add["city"] = address.zipcode + " " + address.city
    add["phone"] = address.phone
    object["address"] = add.to_json
  end
  def add_user order
    was = @users[order.email]
    if was
      add_address( was , order.user.bill_address )
      return
    end
    user = passthrough( order.user , ["email", "encrypted_password", "remember_created_at",  "sign_in_count",
                      "current_sign_in_at",  "last_sign_in_at","current_sign_in_ip" , "last_sign_in_ip" , "created_at"])
    add_address( user , order.user.bill_address )
    @users[user["email"]] = user
  end
  def add_basket order
    @baskets[order.id] = { "kori_id" => order.id , "kori_type" => "Order" , "id" => order.id , "total_price" => order.total ,
           "created_at" => order.created_at }
    order.line_items.each do |item|
      i = passthrough( item , ["id" , "quantity" , "price" ])
      i["basket_id"] = item.order_id #basket and order id are the same (works as there are no purchases in spree)
      i["product_id"] = item.variant_id
      @items[item.id] = i
    end  
  end
  def init_taxons
    @taxons = {}
    all = Spree::Taxon.all
    all.each do |taxon|
      att = passthrough( taxon , ["id" , "name"])
      att[ "link"] = taxon.permalink.split("/").last 
      att["category_id"] = taxon.parent_id 
      @taxons[taxon.id] = att
    end 
  end
  def init_products
    @products = {}
    all = Spree::Variant.all()
    puts "products #{all.length}"
    all.each do |product|
      next if product.deleted_at
      next if product.product and product.product.deleted_at
      att = passthrough( product , [ "name" , "description" , "id",  "price" , "weight" , "ean" ] )
      if product.is_master?
        att["ean"] = "" if product.product.has_variants?
      else
        att["product_id"] = product.product.master.id
        att["name"] = product.options_text
        att["description"] = ""
      end
      att["created_at"] = product.product.created_at
      att[ "link" ] = product.permalink
      att[ "scode" ] = product.sku
      att[ "cost"] = product.cost_price if product.cost_price
      att[ "inventory" ] = product.count_on_hand 
      tax = product.tax_category
      att[ "tax"] = tax.name[3,2].to_f if tax
      att["category_id"] = product.product.taxons.first.id if product.product.taxons.first
      hash , props = {} , product.product.product_properties
      props.each{|prop| hash[prop.property.name] = prop.value}
      att["properties"] = hash.to_yaml
      main = product.images[0]
      att["main_picture_file_name"] = main.attachment_file_name if main
      extra = product.images[1]
      att["extra_picture_file_name"] = extra.attachment_file_name if extra
      att["online"] = !product.available_on.nil?
      @products[product.id] = att
    end 
  end

  def out_orders
    write :orders
    write :users
    write :items
    write :baskets
  end
  def write sym
    file =  File.new("#{@root}#{sym}.yml","w")
    file << eval("@#{sym}.to_yaml")
    puts "written #{sym} : " + eval("@#{sym}.length").to_s
    file.close
  end
  def out_products
    write :products
  end
  def out_taxons
    file =  File.new("#{@root}categories.yml","w")
    file << @taxons.to_yaml
    file.close
  end
  def out
    out_products
    out_taxons
    out_orders
  end
end
