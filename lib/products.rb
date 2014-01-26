module Products
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
      att["properties"] = hash.to_json
      main = product.images[0]
      att["main_picture_file_name"] = main.attachment_file_name if main
      extra = product.images[1]
      att["extra_picture_file_name"] = extra.attachment_file_name if extra
      att["online"] = !product.available_on.nil?
      @products[product.id] = att
    end 
  end
  def write_products
    write :products
  end

end
