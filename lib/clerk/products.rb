module Clerk::Products
  def fix_products
    Product.all.each do |p|
      puts p.full_name
      if p.ean.blank?
        p.ean = p.scode
        p.scode = ""
      end
      p.scode = "" if p.ean == p.scode
      props = p.properties
      #Tuoteryhmä .. if not set before,, and delete both
      supplier = props["Valmistaja"]
      unless supplier.blank?
        p.supplier = Supplier.find_or_create_by_supplier_name supplier
      end
      group = props["Tuoteryhmä"]
      if !p.category and !group.blank?
        group = group.capitalize
        p.category = Category.find_by_name group
        unless p.category
          puts "Link #{group.downcase}"
          p.category = Category.create( :name => group , :link => group.downcase)
        end
      end
      p.properties = ""
      #line prices that have gone askew in time
      if p.line?
        prices = p.products.collect{|u| u.price }
        if(p.price < prices.min) or (p.price > prices.max)
          p.price = prices.min 
        end
        p.inventory = p.products.sum(&:inventory)
      end
      #prices rounded  to 5 cent (in finland that is the smallest coin)
      if p.price 
        p.price = ((p.price / 5.0).round(2)*5.0).round(2)
      else
        p.price = 0.0
      end
      p.save!
    end
  end
end
