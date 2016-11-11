require 'fileutils'
require 'gyoku'
require 'nori'
require 'rest-client'


# Tuotetietokentissä käytettävät arvot ovat seuraavat;
#
# ProductCode ProductName
#
# 10    Bussipaketti
# 30    Jakopaketti
# 40    Rahtipussi
# 42    Rahtipussin jakopaketti
# 43    Dokumenttikuori
# 44    Dokumenttikuoren jakopaketti
# 57    Lavarahti
# 70    Ulkomaan lentoasiakirja
# 71    Ulkomaan lentopaketti
# 72    Ulkomaan paketti
# 80    Verkkopaketti
#
# Erikoiskäsittelykoodit
#
# SpecialHandling Kuvaus
# E01   Vaarallinen aine (VAK-luokka kenttään VAKCode)
# K02   Ympärysmitta
# K03   Tankomainen
# K04   Varoen käsiteltävä


module SpreeMatkahuolto
  class Shipment

    # Currently only required fields are supported

    attr_accessor :shipment_type, # Required
      :message_type, # Required
      :shipment_number,
      :shipment_data,
      :weight, # Required
      :volume,
      :packages, # Required
      :sender_id, # Required
      :sender_name,
      :sender_name2,
      :sender_address,
      :sender_postal,
      :sender_city,
      :sender_contact_name,
      :sender_contact_number,
      :sender_email,
      :sender_reference,
      :departure_place_code,
      :departure_place_name,
      :receiver_name, # Required
      :receiver_name2,
      :receiver_address,
      :receiver_postal, # Required
      :receiver_city, # Required
      :receiver_contact_name,
      :receiver_contact_number,
      :receiver_email,
      :receiver_reference,
      :destination_place_code,
      :destination_place_name,
      :payer_code,
      :payer_id,
      :payer_name,
      :payer_name2,
      :payer_address,
      :payer_postal,
      :payer_city,
      :payer_contact_name,
      :receier_contact_number,
      :payer_email,
      :payer_reference,
      :remarks,
      :product_code, # Required
      :product_name,
      :pickup,
      :pickup_payer,
      :pickup_remarks,
      :delivery,
      :delivery_payer,
      :delivery_remarks,
      :cod_sum,
      :cod_currency,
      :cod_account,
      :cod_bic,
      :cod_reference,
      :goods,
      :special_handling,
      :vak_code,
      :vak_description,
      :document_type,
      :shipment_row,
      :package_id,
      :weight,
      :volume


    def initialize(sender_id)
      @sender_id = sender_id
      @product_code = "30"
      @shipment_type = "N"
      @message_type = "N"
      @packages = 1
      @weight = 1
      @receiver_name = ""
      @receiver_address = ""
      @receiver_city = ""
      @receiver_email =""
      @receiver_postal = ""
      @receiver_contact_name = ""
      @receiver_contact_number = ""
      @destination_place_code = ""
    end

  end
end

module SpreeMatkahuolto
  module API

    class ShippingLabel

      attr_accessor :test_mode

      TEST_ENDPOINT = "https://extservicestest.matkahuolto.fi/mpaketti/mhshipmentxml"
      PRODUCTION_ENDPOINT = "https://extservices.matkahuolto.fi/mpaketti/mhshipmentxml"

      def initialize(login, password, test_mode = false)
        @login = login
        @password = password
        @test_mode = test_mode
      end

      def get_labels(shipments)
        return nil unless shipments
        #shipments = [shipments] unless shipments.is_a?(Array)

        if @test_mode == true
          endpoint = TEST_ENDPOINT
        else
          endpoint = PRODUCTION_ENDPOINT
        end

        request = build_request(shipments)

        begin
          response = RestClient.post endpoint, request, content_type: 'text/xml', accept: :xml
        rescue => e
          Rollbar.error(e)
          raise e
        end

        parser = Nori.new
        parsed_data = parser.parse(response)

        filename = parsed_data['MHShipmentReply']['PdfName']
        path = Rails.root.join("tmp/shipping_labels/#{filename}")
        dirname = File.dirname(path)

        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

        File.open(path, 'wb') do |f|
          f.write(Base64.decode64(parsed_data['MHShipmentReply']['ShipmentPdf']))
        end

        return { filename: "#{filename}", path: "#{path}" }
      end

      private

        def build_request(shipments)

          request = {
            'MHShipmentRequest' => {
              'UserId' => @login,
              'Password' => @password,
              'Version' => '2.0',
              'Shipment' => []
            }
          }

          shipments.each  do |shipment|
            s = {
              'ShipmentType' => shipment.shipment_type,
              'MessageType' => shipment.message_type,
              'Weight' => shipment.weight,
              'Packages' => shipment.packages,
              'SenderId' => shipment.sender_id,
              'SenderReference' => shipment.sender_reference,
              'ReceiverName1' => shipment.receiver_name,
              'ReceiverAddress' => shipment.receiver_address,
              'ReceiverPostal' => shipment.receiver_postal,
              'ReceiverCity' => shipment.receiver_city,
              'ReceiverEmail' => shipment.receiver_email,
              'ReceiverContactName' => shipment.receiver_contact_name,
              'ReceiverContactNumber' => shipment.receiver_contact_number,
              'DestinationPlaceCode' => shipment.destination_place_code,
              'ProductCode' => shipment.product_code
            }

            request['MHShipmentRequest']['Shipment'].push s
          end

          Gyoku.xml(request, { key_converter: :none })
        end

    end

  end
end
