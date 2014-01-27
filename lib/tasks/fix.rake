namespace :db do
  namespace :fix do
    # define a task to run just each defined fixes by eg rake db:fix:orders
    # or db:fix:all
    if defined? Spree
    require "clerk/fix"
    (FIXES + [:all]).each do |mod|
      description =  "Export #{mod} to yaml in clerk format"
      code = "ex = Spree::Export.new; ex.init_#{mod}; ex.write_#{mod}"
      eval "desc '#{description}'; task :#{mod} => :environment do #{code}; end"
    end
  end
end