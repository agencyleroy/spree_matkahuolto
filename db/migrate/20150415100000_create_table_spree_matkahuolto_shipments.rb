class CreateTableSpreeMatkahuoltoShipments < ActiveRecord::Migration
  def change
    create_table :spree_matkahuolto_shipments do |t|
      t.references :order, index: true
      t.integer :destination_code
      t.timestamps
    end
  end
end
