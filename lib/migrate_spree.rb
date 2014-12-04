class SpreeMigration < Rails::Engine

  config.autoload_paths += %W(#{config.root}/lib)

  initializer "init" do |app|
  end
  
end
