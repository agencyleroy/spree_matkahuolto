Deface::Override.new(:virtual_path  => "spree/checkout/_delivery",
                     :replace => "ul.field.radios.shipping-methods",
                     :partial => "shipping_method_matkahuolto",
                     :name          => "shipping_method_matkahuolto")
