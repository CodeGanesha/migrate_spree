require 'rake'

namespace :db do
  namespace :export do
    # define a task to run just each defined model by eg rake db:export:export_users
    # or db:export:export_all
    if defined? Spree
      require "spree/export"
      (MODELS + [:all]).each do |mod|
        #tried long enough to do this with the api but failed. pull welcome
        description =  "Export #{mod} to yaml in clerk format"
        code = "ex = Spree::Export.new; ex.init_#{mod}; ex.write_#{mod}"
        eval "desc '#{description}'; task :#{mod} => :environment do #{code}; end"
      end
    end
  end
end
