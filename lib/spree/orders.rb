#orders are a little different as they do baskets too (as those are new), 
#   items as they are attached 

module Spree::Orders

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
      add_basket(order)
      add_address(order , order.bill_address)
      @orders[order.id] = att
    end
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
  def write_orders
    write :orders
    write :items
    write :baskets
  end
end
