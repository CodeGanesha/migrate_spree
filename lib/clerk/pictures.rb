module Clerk::Pictures
  OLD_ROOT = "/Users/raisa/tukku"
  def fix_pictures
    Product.all.each do |p|
      next if p.main_picture_file_name.blank?
      next if p.main_picture_file_size
      file = Dir["#{OLD_ROOT}/public/spree/products/*/original/#{p.main_picture_file_name}"].first
      next unless file
      f1 = File.open file
      f2 = nil
      p.main_picture =  f1
      puts "Main " + file
      unless p.extra_picture_file_name.blank?
        file = Dir["#{OLD_ROOT}/public/spree/products/*/original/#{p.extra_picture_file_name}"].first
        if file
          f2 =  File.open file
          p.extra_picture = f2
          puts "Extra " + file
        end
      end
      p.save!
      f1.close
      f2.close if f2
    end
  end
end
