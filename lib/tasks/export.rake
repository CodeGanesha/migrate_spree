require 'rake'

namespace :db do
  desc "Export all object to yaml in clerk format"
  task :export => :environment do
    require "export"
    ex = Export.new "/Users/raisa/office_clerk/test/fixtures/"
    ex.init_all
    ex.out
  end
  desc "Export all products to yaml in clerk format"
  task :export_products => :environment do
    require "export"
    ex = Export.new "/Users/raisa/office_clerk/test/fixtures/"
    ex.init_products
    ex.out_products
  end
end
