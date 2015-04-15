Spree::Shipment.class_eval do
  has_one :custom_shipment
  delegate :has_matkahuolto, to: :custom_shipment, prefix: false, allow_nil: true

  accepts_nested_attributes_for :custom_shipment

  before_create :build_default_custom_shipment

  private
  def build_default_custom_shipment
    build_custom_shipment
    true # Always return true in callbacks as the normal 'continue' state
  end
end