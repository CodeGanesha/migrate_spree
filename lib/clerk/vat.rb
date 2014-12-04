# this fixes a dataset where prices were stored without vat
# as this is maybe not common it is not included in the list 
# nor done in the product/item loops

module Clerk::Vat
  def fix_price object
    price = object.price
    price = price * (100.0 + object.tax) / 100.0
    object.price = price.round(2)
  end

  def fix_vat
    Product.all.each do |p|
      fix_price p
      p.save!
    end
    Item.all.each do |i|
      i.tax = i.product.tax
      fix_price i
      i.save!
    end
    Order.all.each do |o|
      o.shipment_price = ( o.shipment_price * 1.24).round(2)
      o.save
    end
  end
end