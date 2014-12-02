#orders are a little different as they do baskets too (as those are new), 
#   items as they are attached 

module Spree::Orders
  def init_orders
    @orders = {}
    @items = {}
    @baskets = {}
    orders = Spree::Order.where(:state => "complete" )
    puts "orders #{orders.length}"
    orders.each do |order|
      att = passthrough( order , ["id" , "email" , "number" , "created_at"])
      att["ordered_on"] = order.completed_at
      add_basket(order)
      add_address(att , order.bill_address)
      att["shipped_on"] = order.completed_at
      if(shipment = order.shipments.first)
        att["shipment_price"] = shipment.cost
        att["shipment_type"] = shipment.shipping_method ? shipment.shipping_method.name : ""
        att["shipment_tax"] = 24.0
        att["shipped_on"] = shipment.shipped_at.to_date if shipment.shipped_at
      else
        att["shipment_price"] = 0.0
      end
      if( payment = order.payments.first )
        att["payment_type"] = payment.payment_method.name if payment.payment_method
      end
      att["paid_on"] = order.completed_at
      @orders[order.id] = att
    end
  end
  def add_basket order
    @baskets[order.id] = { "kori_id" => order.id , "kori_type" => "Order" , "id" => order.id , 
                           "total_price" => order.total , "created_at" => order.created_at }
    order.line_items.each do |item|
      i = passthrough( item , ["id" , "quantity" , "price" ])
      #basket and order id are the same (works as there are no purchases in spree)
      i["basket_id"]  = item.order_id 
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
