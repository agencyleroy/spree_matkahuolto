Spree::Core::Engine.add_routes do
  get 'admin/orders/:id/matkahuolto_labels' => 'admin/orders#matkahuolto_labels', as: :get_matkahuolto_labels_admin_order
end