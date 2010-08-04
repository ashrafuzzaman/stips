require 'active_merchant/billing/gateways/payson/payson_response'
require 'active_merchant/billing/gateways/payson/payson_payment_details_response'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaysonGateway < Gateway
      ENDPOINT_URLS = {
        :production => {
          :authorize => 'https://api.payson.se/1.0/Pay/',
          :pay => 'https://www.payson.se/PaySecure/',
          :payment_details => 'https://api.payson.se/1.0/PaymentDetails/'
        }
      } unless defined?(ENDPOINT_URLS)

      ACTIONS_WITH_URL_TOKEN = [:pay] unless defined?(ACTIONS_WITH_URL_TOKEN)

      # The name of the gateway
      self.display_name = 'Payson'
      # The homepage URL of the gateway
      self.homepage_url = 'https://api.payson.se'
      # The countries the gateway supports merchants from as 2 digit ISO country codes
      self.supported_countries = ['SE']
      # The default currency for the transactions if no currency is provided
      self.default_currency = 'SEK'
      # The format of the amounts used by the gateway
      # :dollars => '12.50'
      # :cents => '1250'
      self.money_format = :dollars

      attr_accessor :options
      attr_accessor :post
      alias :request_params :post

      def initialize(options = {})
        requires!(options, :login, :password)
        @options = options
        super
      end

      # Authorize a payment to receive a unique payment token.
      def authorize(options = {})
        @post = ActiveMerchant::PostData.new

        self.add_receivers(options)
        self.add_customer(options)
        self.add_meta(options)
        self.add_callbacks(options)

        response = commit(:authorize)
        @token = response.success? ? response.token : nil
        response
      end

      # Get the Payson URL to redirect to for collecting payment.
      def payment_redirection_url(token = nil)
        self.endpoint_url_with_token(:pay, token)
      end

      # Get payment details if available for a payment identified by a known payment token.
      # Used for validating a payment as well.
      def payment_details(token = nil)
        @post = ActiveMerchant::PostData.new

        self.add_token(token)

        commit(:payment_details)
      end
      alias :details_for :payment_details # PayPal Express...

      def self.supported_currencies
        ["SEK", "EUR"]
      end

      protected

      # Add payment receviers (at least one). Required params are +:email+ and +:amount+ in SEK or EUR.
      def add_receivers(options)
        requires!(options, :receivers)
        options[:receivers].each_with_index do |v, i|
          @post["receiverList.receiver(#{i}).email"] = v[:email]
          @post["receiverList.receiver(#{i}).amount"] = v[:amount]
        end
      end

      # Add customer e-mail for identification, i.e. the one the sent the payment.
      def add_customer(options)
        requires!(options, :sender)
        @post.merge!('senderEmail' => options[:sender][:email],
          'senderFirstName' => options[:sender][:first_name],
          'senderLastName' => options[:sender][:last_name])
      end

      # Add callback URLs that Payson should redirect to upon successful or failed/canceled payment.
      def add_callbacks(options)
        requires!(options, :return_url, :cancel_url)
        @post.merge!('returnUrl' => options[:return_url],
          'cancelUrl' => options[:cancel_url])
      end

      # Add additional payment details, for tracking.
      def add_meta(options)
        requires!(options, :memo)
        options[:currency_code] = self.default_currency unless self.class.supported_currencies.include?(options[:currency_code].to_s)
        @post.merge!('custom' => options[:custom],
          'memo' => options[:memo],
          'currencyCode' => options[:currency_code])
      end

      def add_token(token)
        @post.merge!(:token => token)
      end

      # Set required Payson API headers.
      def headers(options = {})
        options.merge!(@options)
        {'PAYSON-SECURITY-USERID' => options[:login],
          'PAYSON-SECURITY-PASSWORD' => options[:password]}
      end

      # Get the API endpoint URL for specified action.
      def endpoint_url(action)
        return '' if action.blank?
        ENDPOINT_URLS[self.gateway_mode][action.to_sym] rescue ENDPOINT_URLS[:production][action.to_sym]
      end

      # Get the API endpoint URL for a specified action with the current/specified token as param.
      def endpoint_url_with_token(action, token = nil)
        @token = token if token
        "#{endpoint_url(action)}?token=#{@token}"
      end

      def post_data
        @post.present? ? @post.to_post_data : ""
      end

      # Perform API call with specified action and optionally additional params.
      def commit(action)
        url = endpoint_url(action)
        response_body = ssl_post(url, post_data, headers)
        #ActiveMerchant::Billing::PaysonResponse.new(response_body)
        if action.to_sym == :payment_details
          ActiveMerchant::Billing::PaysonPaymentDetailsResponse.new(response_body)
        else
          ActiveMerchant::Billing::PaysonResponse.new(response_body)
        end
      end

    end
  end
end
