require "spree"

MODELS = [:orders , :products , :taxons]
EXPORT_TO = "/Users/raisa/office_clerk/test/fixtures/"

MODELS.each do |mod|
  require mod.to_s
end

# we generate a fixture for each model that we want to export.
# orders are a litle different , see orders module
# provide some helpers and the mechanism to require, init and write models
class Export
  def initialize 
    MODELS.each do |mod|
      self.class.send :include ,  eval(mod.to_s.capitalize)
    end
  end
  #initialize all models, don't do in initializer so we can only run one model if we want
  def init_all
    MODELS.each do |mod|
      self.send "init_#{mod}" 
    end
  end
  def write_all
    MODELS.each do |mod|
      self.send "write_#{mod}" 
    end
  end
  # little helper to write the hash. 
  def write sym
    file =  File.new("#{EXPORT_TO}#{sym}.yml","w")
    file << eval("@#{sym}.to_yaml")
    puts "written #{sym} : " + eval("@#{sym}.length").to_s
    file.close
  end
  #many attribute names a re the same, so we pass them through to the clerk hash we are creating
  def passthrough object , attributes
    ret = {}
    attributes.each do |name|
      ret[name.to_s] = object.send(name)
    end
    ret
  end
  # in clerk addresses are "inline" , not seperate objects, and have less attriubtes 
  # so a helper to transfer them
  def add_address object , address
    return unless address
    add = {}
    add["name"] = address.firstname + " " + address.lastname
    add["street"] = address.address1 + " " + address.address2.to_s
    add["city"] = address.zipcode + " " + address.city
    add["phone"] = address.phone
    object["address"] = add.to_json
  end
end
