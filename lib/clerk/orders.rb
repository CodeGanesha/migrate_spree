
module Clerk::Orders

  #deleting items that have (for inexplicable reasons) no product anymore.
  def fix_orders
    Order.all.each do |order|
      puts "order #{order.number}"
      del = false
      del = true if order.created_at.year < 2012
      order.basket.items.each do |item|
        begin
          del = true unless item.product
          item.name = item.product.full_name
        rescue # means deleted product, 
          del = true
        end
        del ? item.delete :  item.save! 
      end
      if(del)
        order.basket.delete
        order.delete
      end
    end
  end
end
