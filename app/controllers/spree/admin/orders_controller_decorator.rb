Spree::Admin::OrdersController.class_eval do

  def matkahuolto_labels
    @order = Spree::Order.find_by(number:params[:id])
    return unless @order

    label_api = Matkahuolto::API::ShippingLabel.new(
      Spree::Config.matkahuolto_username,
      Spree::Config.matkahuolto_password,
      Spree::Config.matkahuolto_test_mode
    )

    shipments = []

    @order.shipments.each do |s|
      # TODO: Change API Login
      m_shipment = Matkahuolto::Shipment.new(Spree::Config.matkahuolto_username)

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

      # This builds the custom_shipment for older orders. New shipments are built with the custom_shipment automatically
      if not s.try(:custom_shipment)
        s.custom_shipment = CustomShipment.create(shipment_id:s.id)
      end
      # End
      if s.custom_shipment.has_matkahuolto
        m_shipment.message_type = "C"
      else
        custom_s = s.custom_shipment
        custom_s.has_matkahuolto = true
        custom_s.save
      end
      shipments.push m_shipment
    end

    label = label_api.get_labels(shipments)

    send_file label[:path], filename: label[:filename], type: "application/pdf"
  end

end
