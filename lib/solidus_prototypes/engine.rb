module SolidusPrototypes
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_prototypes'

    config.autoload_paths += %W(#{config.root}/lib/concerns)
    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../lib/decorators/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)

    initializer "solidus_prototypes.add_product_tabs" do |app|
      Spree::BackendConfiguration::PRODUCT_TABS.push(:prototypes)
    end
  end
end
