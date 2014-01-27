#left over from a spree engine i copied, left here "just in case"

class SpreeMigration < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.register.calculators" do |app|
    end
end
