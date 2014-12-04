
MODELS = [:orders , :products , :taxons , :users]

MODELS.each do |mod|
  require "spree/#{mod}"
end

# we generate a fixture for each model that we want to export.
# orders are a litle different , see orders module
# provide some helpers and the mechanism to require, init and write models
class Spree::Export
  def initialize
    @export_dir = File.join(Rails.root, "test" ,"fixtures")
    MODELS.each do |mod|
      self.class.send :include ,  eval("Spree::#{mod.to_s.capitalize}")
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
  # little helper to write the hash. Sym is symbol with the same name as the instance variable to write.
  # optional second arg is the filename, when not given  defaults to sym. 
  # Use @export_dir which defaults to rails.root/test/fixtures
  def write sym , filename = nil
    filename = sym unless filename
    instance = eval "@#{sym}"
    file =  File.new(File.join(@export_dir , "#{filename}.yml") ,"w")
    file << instance.to_yaml('Encoding' => 'UTF-8')
    puts "written #{sym} : " + instance.length.to_s
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
    add["street"] = address.address1.to_s + " " + address.address2.to_s
    add["city"] = address.zipcode + " " + address.city
    add["phone"] = address.phone
    object["address"] = add
  end
end
