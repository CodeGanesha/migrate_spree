
module Clerk::Orders

  def fix_orders
    Order.all.each do |order|
      puts "order #{order.number}"
      del = false
      del = true if order.created_at.year < 2012
      order.basket.items.each do |item|
        if item.product
          item.price *= (100.0 + item.product.tax ) / 100.0
          item.tax = item.product.tax
          item.tax = 24.0 if item.tax < 0.1   #this "should" be the default system tax
        else
          del = true
        end
        del ? item.delete :  item.save! 
      end
      if(del)
        order.basket.delete
        order.delete
      else
        order.basket.save!
        order.save!
      end
    end
  end
end
