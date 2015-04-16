class CreateTableSpreeMatkahuoltoCustomShipments < ActiveRecord::Migration
  def change
    create_table :spree_matkahuolto_custom_shipments do |t|
      t.integer :shipment_id
      t.boolean :has_matkahuolto, default: false
    end
  end
end
