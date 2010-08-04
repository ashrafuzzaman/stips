require 'active_merchant/billing/gateways/payson'

class Payson < ActiveMerchant::Billing::PaysonGateway
  attr_accessor :amount, :response

  def initialize(amount=nil)
    @amount = amount
    super({:login => "4024", :password => "24a4fa58-3b42-42f5-92d3-1c6fb5ec4f89"})
  end

  def pay(options = {})
    options.merge!({:receivers => [{:email => "info@simplesignup.se", :amount => @amount.to_s}] })
    @response = authorize(options)
    self
  end

  def self.payment_details(token)
    api = self.new
    api.payment_details token
  end
end