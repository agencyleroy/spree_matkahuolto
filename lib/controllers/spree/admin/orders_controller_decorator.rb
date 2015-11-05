Spree::Admin::OrdersController.class_eval do

  def matkahuolto_labels

    @order = Spree::Order.find_by(number:params[:id])
    return unless @order
    s = Spree::Shipment.find_by(number:params[:shipment_id])
    return unless s

    label_api = SpreeMatkahuolto::API::ShippingLabel.new(
      Rails.configuration.x.matkahuolto_username,
      Rails.configuration.x.matkahuolto_password,
      Rails.configuration.x.matkahuolto_test_mode,
      # ENV["#{Rails.env.upcase}_MATKAHUOLTO_USERNAME"],
      # ENV["#{Rails.env.upcase}_MATKAHUOLTO_PASSWORD"],
      # ENV["#{Rails.env.upcase}_MATKAHUOLTO_TEST_MODE"]
    )

    shipments = []

    # TODO: Change API Login
    m_shipment = SpreeMatkahuolto::Shipment.new(Rails.configuration.x.matkahuolto_username)

    if s.shipping_method.admin_name.include? "matkahuolto_lahella"
      destination_code = Spree::MatkahuoltoShipment.where(order_id: @order.id).first.try(:destination_code)

      if destination_code
        m_shipment.destination_place_code = destination_code
        m_shipment.product_code = "80"
      end
    end

    m_shipment.sender_reference = "Order: #{@order.number}"
    m_shipment.receiver_name = "#{s.address.first_name} #{s.address.last_name}"
    m_shipment.receiver_address = "#{s.address.address1} #{s.address.address2}"
    m_shipment.receiver_postal = "#{s.address.zipcode}"
    m_shipment.receiver_city = "#{s.address.city}"
    m_shipment.receiver_contact_name = "#{s.address.first_name} #{s.address.last_name}"
    m_shipment.receiver_contact_number = "#{s.address.phone}"
    m_shipment.receiver_email = "#{@order.email}"
    total_weight = 0.0
    s.line_items.each do |item|
      total_weight += item.try(:product).try(:weight)
    end
    if total_weight == 0.0
      total_weight = 1.0
    end
    m_shipment.weight = total_weight.to_s

    
    custom_s = SpreeMatkahuoltoCustomShipment.find_by(shipment_id:s.id)
    if custom_s and custom_s.label_file_name
      # m_shipment.message_type = "C"
      return send_file custom_s.label.path, type: "application/pdf"
    end

    shipments.push m_shipment
    
    label = label_api.get_labels(shipments)

    custom_s = SpreeMatkahuoltoCustomShipment.find_by(shipment_id:s.id)
    if not custom_s
      custom_s = SpreeMatkahuoltoCustomShipment.create(shipment_id:s.id)
    end
    label_path = label[:path]
    label_file = File.open(label_path, 'r')
    custom_s.label = label_file
    custom_s.save

    send_file label[:path], filename: label[:filename], type: "application/pdf"
  end

end
