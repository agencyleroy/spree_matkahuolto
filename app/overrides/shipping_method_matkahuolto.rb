Deface::Override.new(:virtual_path  => "spree/checkout/_delivery",
                     :replace => "ul.field.radios.shipping-methods",
                     :partial => "spree/overrides/shipping_method_matkahuolto",
                     :name          => "shipping_method_matkahuolto")
