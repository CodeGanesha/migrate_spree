
FIXES = [:orders , :products , :pictures]

# like the export class, just providing some mechanics for the modules/fixes
# fixes are a one (not two) step process . ie no writing
module Clerk
  class Fix
    def initialize
      FIXES.each do |mod|
        self.class.send :include ,  eval("Clerk::#{mod.to_s.capitalize}")
      end
    end
    #initialize all models, don't do in initializer so we can only run one model if we want
    def fix_all
      FIXES.each do |mod|
        self.send "fix_#{mod}"
      end
    end
  end
end

FIXES.each do |mod|
  require "clerk/#{mod}"
end
