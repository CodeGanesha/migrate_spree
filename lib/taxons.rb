module Taxons
  def init_taxons
    @taxons = {}
    all = Spree::Taxon.all
    all.each do |taxon|
      att = passthrough( taxon , ["id" , "name"])
      att[ "link"] = taxon.permalink.split("/").last 
      att["category_id"] = taxon.parent_id 
      @taxons[taxon.id] = att
    end 
  end
  def write_taxons
    file =  File.new("#{EXPORT_TO}categories.yml","w")
    file << @taxons.to_yaml
    file.close
  end
end
