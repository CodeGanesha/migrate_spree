require 'rake'

namespace :db do
  desc "Export all object to yaml in clerk format"
  task :export => :environment do
    require "export"
    ex = Export.new
    ex.init_all
    ex.write_all
  end
  desc "Export all products to yaml in clerk format"
  task :export_products => :environment do
    require "export"
    ex = Export.new 
    ex.init_products
    ex.write_products
  end
end
