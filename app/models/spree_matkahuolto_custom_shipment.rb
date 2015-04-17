class SpreeMatkahuoltoCustomShipment < ActiveRecord::Base
  belongs_to :shipment, class_name: 'Spree::Shipment'
  has_attached_file :label
  validates_attachment_content_type :label, content_type: ['application/pdf']
end