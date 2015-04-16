module SpreeMatkaHuolto
  class Engine < Rails::Engine
    engine_name 'spree_matkahuolto'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.matkahuolto.preferences", :after => "spree.register.payment_methods" do |app|
        app.config.x.matkahuolto_username =  ENV["#{Rails.env.upcase}_MATKAHUOLTO_USERNAME"]
        app.config.x.matkahuolto_password =  ENV["#{Rails.env.upcase}_MATKAHUOLTO_PASSWORD"]
        app.config.x.matkahuolto_test_mode =  ENV["#{Rails.env.upcase}_MATKAHUOLTO_TEST_MODE"]
    #   app.config.spree.payment_methods << Spree::Gateway::Worldpay
    end

    def self.activate
      if SpreeMatkaHuolto::Engine.frontend_available?
        Rails.application.config.assets.precompile += [
          'lib/assets/javascripts/shipping_method_matkahuolto.js.coffee',
          'lib/assets/stylesheets/shipping_method_matkahuolto.scss',
        ]
        Dir.glob(File.join(File.dirname(__FILE__), "../controllers/spree/admin/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end
    end

    def self.backend_available?
      @@backend_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Backend::Engine')
    end

    def self.frontend_available?
      @@frontend_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Frontend::Engine')
    end

    paths["app/overrides"] ||= []

    if self.backend_available?
      paths["app/controllers"] << "lib/controllers/spree/admin"
      paths["app/overrides"] << "lib/overrides/backend"
      paths["app/models"] << "lib/models/decorators"
      paths["app/views"] << "lib/views/spree"
    end

    if self.frontend_available?
      paths["app/overrides"] << "lib/overrides/frontend" 
      paths["app/views"] << "lib/views/spree"
    end

    config.to_prepare &method(:activate).to_proc
  end
end