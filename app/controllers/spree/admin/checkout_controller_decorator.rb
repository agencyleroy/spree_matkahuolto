Spree::CheckoutController.class_eval do
  before_filter :load_matkahuolto_delivery
  before_filter :save_matkahuolto_destination_shipment

  def edit
    @no_header = true
  end

  def load_matkahuolto_delivery
    return unless ["delivery"].include? @order.state

    api = Matkahuolto::API::OfficeFinder.new(Spree::Config.matkahuolto_username)
    @matkahuolto_destinations = api.find(@order.ship_address.address1, @order.ship_address.zipcode, @order.ship_address.city)
    @matkahuolto_selected_destination_code = Spree::MatkahuoltoShipment.where(order_id: @order.id).first.try(:destination_code)
  end

  def save_matkahuolto_destination_shipment
    return unless "update" == params[:action] && "delivery" == params[:state]

    destination_code = params[:matkahuolto_selected_destination_id]

    matkahuolto_shipment = Spree::MatkahuoltoShipment.where(order_id: @order.id).first
    # Delete record for order if not using matkahuolto lahella
    if matkahuolto_shipment && !destination_code
      matkahuolto_shipment.destroy
      return
    end

    unless matkahuolto_shipment
      matkahuolto_shipment = Spree::MatkahuoltoShipment.new
    end

    matkahuolto_shipment.destination_code = destination_code
    matkahuolto_shipment.order = @order
    matkahuolto_shipment.save
  end

end
