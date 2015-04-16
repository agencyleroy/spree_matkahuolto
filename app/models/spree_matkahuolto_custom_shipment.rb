class SpreeMatkahuoltoCustomShipment < ActiveRecord::Base
  belongs_to :shipment, class_name: 'Spree::Shipment'
end