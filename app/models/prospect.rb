class Prospect < ApplicationRecord
  has_many :prospect_calls, inverse_of: :prospect, :dependent => :destroy
  accepts_nested_attributes_for :prospect_calls, reject_if: proc { |attributes| attributes['who'].blank? }
  validates_presence_of :name
  validates_presence_of :zip
  validate :zip_code

  def self.get_orders
    all.each do |p|
      if !p.customer_id.blank?
        # active prospect with a customer code
        if p.ship_to.blank? || p.ship_to == p.customer_id
          sales = DartSalesPricingCurrent.where(cust_code: p.customer_id).where("sale_date >= ?", 8.weeks.ago).where("sales_dol > ?", 0).uniq{|s| s.order_numb}.take(3)
        else
          sales = DartSalesPricingCurrent.where(shipto_code: p.ship_to).where("sale_date >= ?", 8.weeks.ago).where("sales_dol > ?", 0).uniq{|s| s.order_numb}.take(3)
        end
        if sales && sales.length == 3
          # this customer is no longer a prospect so set it to inactive
          p.status = true
          p.customer = true
          p.save
        end
      end
    end
  end

  def zip_code
    if zip.present?
      a = Geocode.where(["zip = ?", zip])
      if a.length == 0
        errors.add(:zip, " code invalid")
      end
    end
  end

end
