class Prospect < ApplicationRecord
  has_many :prospect_calls, inverse_of: :prospect, :dependent => :destroy
  accepts_nested_attributes_for :prospect_calls, reject_if: proc { |attributes| attributes['who'].blank? }
end
