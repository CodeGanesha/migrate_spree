namespace :db do
  namespace :fix do
    # define a task to run just each defined fixes by eg rake db:fix:orders
    # or db:fix:all
    if !defined? Spree
      require "clerk/fix"
      (FIXES + [:all]).each do |mod|
        description =  "Fix #{mod} in clerk db"
        code = "fix = Clerk::Fix.new; fix.fix_#{mod};"
        eval "desc '#{description}'; task :#{mod} => :environment do #{code}; end"
      end
    end
  end
end