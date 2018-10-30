class ProspectCall < ApplicationRecord
  belongs_to :prospect, :foreign_key => "prospect_id"
end
