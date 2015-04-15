module Spree
  class MatkahuoltoShipment < Spree::Base
    self.table_name = 'spree_matkahuolto_shipments'

    belongs_to :order, class_name: 'Spree::Order'

    
  end
end
