class AddTimestampsToSpreeMatkahuoltoCustomShipments < ActiveRecord::Migration
  def change
    add_column :spree_matkahuolto_custom_shipments, :created_at, :datetime
    add_column :spree_matkahuolto_custom_shipments, :updated_at, :datetime
  end
end
