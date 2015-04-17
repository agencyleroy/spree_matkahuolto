class RemoveHasMatkahuoltoFromSpreeMatkahuoltoCustomShipments < ActiveRecord::Migration
  def change
    remove_column :spree_matkahuolto_custom_shipments, :has_matkahuolto, :boolean, default: false
  end
end
