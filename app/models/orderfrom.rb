class Orderfrom < ApplicationRecord
  establish_connection "e21prod".to_sym
  self.table_name = "vw_orderfrom"
end