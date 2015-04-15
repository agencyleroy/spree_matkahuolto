require 'net/http'
require 'uri'

module SpreeMatkahuolto
  class Office

    attr_accessor :seq_number, :id, :type, :name, :street_address, :postal_code,
      :city, :country, :distance

  end
end

module SpreeMatkahuolto
  module API
    class OfficeFinder

      def initialize(login)
        #@login = login
        # TODO: Only works with this test credentials
        @login = "1234567"
      end

      def find(street_address='', postal_code='', city='', country='FI')
        fields = default_options.merge({
         'StreetAddress' => street_address,
         'PostalCode'=> postal_code,
         'City' => city,
         'Country' => country
         })

        request = build_request(fields)

        begin
          response = RestClient.post "http://map.matkahuolto.fi/map24mh/searchoffices",
            request, :content_type => 'text/xml', :accept => :xml

        rescue # if for some reason the request doesn't work, immediately give up
          return []
        else
          response = clean_response(response)
          extract_offices_from_request(response)
        end
      end

      private

        def default_options
          {}
        end

        # the response is html encoded and with ISO-8859-1 and some other weird
        # encodings nokogiri doesnt like
        def clean_response(response)
          response = URI.unescape(response)
           .force_encoding(Encoding::ISO_8859_1)
           .encode('UTF-8')
           .gsub(/\<\?xml(.*)\?>/,'')
           .gsub(/\+/, ' ')
        end

        def extract_offices_from_request(response)
          parser = Nori.new
          parsed_data = parser.parse(response)
          if parsed_data['MHSearchOfficesReply'].has_key?("ErrorNbr")
            return []
          end
          offices = []
          return offices unless parsed_data['MHSearchOfficesReply'].has_key?("Office")
          parsed_data['MHSearchOfficesReply']['Office'].each do |office|
            o = Office.new
            o.seq_number = office['SeqNumber']
            o.id = office['Id']
            o.type = office['Type']
            o.name = office['Name']
            o.street_address = office['StreetAddress']
            o.postal_code = office['PostalCode']
            o.city = office['City']
            o.country = office['Country']
            o.distance = office['Distance']
            offices.push o
          end
          offices
        end

        def build_request(fields)
          data = {
            'Login' => @login,
            'Version' => '1.9',
            'ResponseType' => 'XML',
            'MaxResults' => '5',
            'Tuko' => 'Y',
            'RussianPoint' => 'N'
          }
          data = data.merge(fields)
          Gyoku.xml({ MH_search_offices_request: data }, { :key_converter => :none })
        end

    end
  end
end
