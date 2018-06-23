class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :flight
  belongs_to :price
  has_one :payment

  enum pay_status: [:not_yet,:paid,:refunded]
  def self.pay_status_names
    @@pay_status_names
  end

  @@pay_status_names = {
      self.pay_statuses[:not_yet]=> '尚未付款',
      self.pay_statuses[:paid]=> '已经支付',
      self.pay_statuses[:refunded]=>'已经退款'
  }
  def get_pay_status_name
    @@pay_status_names[Ticket.pay_status_names[self.pay_status.to_i]]
  end
end
