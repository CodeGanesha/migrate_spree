
module Clerk::Orders

  #deleting items that have (for inexplicable reasons) no product anymore.
  def fix_orders
    Order.all.each do |order|
      puts "order #{order.number}"
      del = false
      del = true if order.created_at.year < 2012
      order.basket.items.each do |item|
        del = true unless item.product
        del ? item.delete :  item.save! 
      end
      if(del)
        order.basket.delete
        order.delete
      end
    end
  end
end
