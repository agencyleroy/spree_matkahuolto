Deface::Override.new(:virtual_path  => "spree/admin/orders/_shipment",
                     :insert_bottom => "tr.show-method.total>td[colspan='4']",
                     :partial => "spree/overrides/admin/orders/print_matkahuolto_shipping_labels",
                     :name          => "admin_print_matkahuolto_shipping_labels")
