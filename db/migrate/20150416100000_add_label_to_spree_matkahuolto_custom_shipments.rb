class AddLabelToSpreeMatkahuoltoCustomShipments < ActiveRecord::Migration
  def change
    add_attachment :spree_matkahuolto_custom_shipments, :label
  end
end
