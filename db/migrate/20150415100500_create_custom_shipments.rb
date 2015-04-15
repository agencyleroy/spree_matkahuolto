class CreateCustomShipments < ActiveRecord::Migration
  def change
    create_table :custom_shipments do |t|
      t.integer :shipment_id
      t.boolean :has_matkahuolto, default: false
    end
  end
end
