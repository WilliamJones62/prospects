class DartSalesPricingCurrent < ApplicationRecord
  establish_connection "e21prod".to_sym
  self.table_name = "dart_Sales_Pricing"
end
