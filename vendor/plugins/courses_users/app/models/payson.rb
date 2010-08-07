require 'active_merchant/billing/gateways/payson'

class Payson < ActiveMerchant::Billing::PaysonGateway
  attr_accessor :amount, :response

  def initialize(amount=nil)
    @amount = amount
    super({:login => "dddd", :password => "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"})
  end

  def pay(options = {})
    options.merge!({:receivers => [{:email => "info@stips.se", :amount => @amount.to_s}] })
    @response = authorize(options)
    self
  end

  def self.payment_details(token)
    api = self.new
    api.payment_details token
  end
end