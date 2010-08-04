require 'test_helper'

class PaysonTest < Test::Unit::TestCase

  AUTHORIZATION_URL = "https://api.payson.se/1.0/Pay/"
  PAYMENT_REDIRECT_URL = "https://www.payson.se/PaySecure/"
  PAYMENT_DETAILS_URL = "https://api.payson.se/1.0/PaymentDetails/"

  SUCCESSFUL_TOKEN = "5df04540-f103-4598-8567-5fc2e9fdcde6"
  INVALID_TOKEN = "123ABC"

  def setup
    @gateway = PaysonGateway.new(valid_credentials)

    @amount = 1.00

    @valid_authorize_options = {
      :receivers => [{:email => "ashraf@example.com", :amount => @amount}],
      :sender => {:email => "grimen@example.com", :first_name => "Jonas", :last_name => "Grimfelt"},
      :return_url => "http://test.smackaho.st:3000/success",
      :cancel_url => "http://test.smackaho.st:3000/failure",
      :memo => "test"
    }
  end

  def test_default_currency
    assert_equal 'SEK', PaysonGateway.default_currency
  end

  def test_supported_countries
    assert_equal ['SE'].sort, [*PaysonGateway.supported_countries].sort
  end

  def test_supported_currencies
    assert_equal 'SEK', PaysonGateway.default_currency
  end

  def test_should_require_receviers
    assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.except(:receivers)) }
    # TODO: Handle obvious invalid input formats in a leaner way.
    # assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.merge(:receivers => [])) }
    # assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.merge(:receivers => [{}])) }
  end

  def test_should_require_sender
    assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.except(:sender)) }
    # TODO: Handle obvious invalid input formats in a leaner way.
    # assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.merge(:sender => nil)) }
    # assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.merge(:sender => {})) }
  end

  def test_should_require_return_url
    assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.except(:return_url)) }

  end

  def test_should_require_cancel_url
    assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.except(:cancel_url)) }
  end

  def test_should_require_memo
    assert_raise(ArgumentError) { @gateway.authorize(@valid_authorize_options.except(:memo)) }
  end

  def test_payment_redirection_url
    assert_equal "#{PAYMENT_REDIRECT_URL}?token=#{INVALID_TOKEN}", @gateway.payment_redirection_url(INVALID_TOKEN)
  end

  def test_payson_response
    response = PaysonResponse.new(successful_authorization_response_body)

    assert_respond_to response, :status
    assert_instance_of String, response.status
    assert_equal "SUCCESS", response.status

    assert_respond_to response, :token
    assert_instance_of String, response.token
    assert_equal SUCCESSFUL_TOKEN, response.token

    assert_respond_to response, :params
    assert_instance_of Hash, response.params

    assert_respond_to response, :body
    assert_instance_of String, response.body
    assert_equal successful_authorization_response_body.strip, response.body
  end

  def test_payson_payment_details_response
    response = PaysonPaymentDetailsResponse.new(successful_payment_details_response_body)

    assert_equal ['CREATED', 'PENDING', 'PROCESSING', 'COMPLETED', 'INCOMPLETE', 'ERROR', 'EXPIRED', 'REVERSALERROR'], PaysonPaymentDetailsResponse::STATUSES
    PaysonPaymentDetailsResponse::STATUSES.each do |status|
      assert_respond_to response, :"#{status.downcase}?"
    end
    assert response.completed?
    assert !response.pending?
    # etc...
  end

  def test_failed_authorization_with_invalid_credentials
    gateway = PaysonGateway.new(invalid_credentials)
    gateway.expects(:ssl_post).returns(failed_with_invalid_credentials_body)

    response = gateway.authorize(@valid_authorize_options)

    assert_instance_of PaysonResponse, response
    assert response.fail?
    assert !response.success?
  end

  def test_successful_authorization
    @gateway.expects(:ssl_post).
      with(authorization_url, successful_authorization_request_body.strip, valid_request_headers).
      returns(successful_authorization_response_body)

    response = @gateway.authorize(@valid_authorize_options)

    assert_instance_of PaysonResponse, response
    assert response.success?
    assert !response.fail?
  end

  def test_failed_authorization
    gateway = PaysonGateway.new(invalid_credentials)
    gateway.expects(:ssl_post).returns(failed_with_invalid_credentials_body)

    response = gateway.authorize(@valid_authorize_options)

    assert_instance_of PaysonResponse, response
    assert response.fail?
    assert !response.success?
  end

  def test_successful_payment_details
    @gateway.expects(:ssl_post).
      with(payment_details_url, successful_payment_details_request_body.strip, valid_request_headers).
      returns(successful_payment_details_response_body)

    response = @gateway.payment_details(SUCCESSFUL_TOKEN)

    assert_instance_of PaysonPaymentDetailsResponse, response
    assert response.success?
    assert !response.fail?
  end

  def test_failed_payment_details
    @gateway.expects(:ssl_post).
      with(payment_details_url, failed_payment_details_request_body.strip, valid_request_headers).
      returns(failed_payment_details_response_body)

    response = @gateway.payment_details(INVALID_TOKEN)

    assert_instance_of PaysonPaymentDetailsResponse, response
    assert !response.success?
    assert response.fail?
  end

  protected

    def valid_credentials
      {
        :login => 'sigge',
        :password => 'sigge123'
      }
    end

    def invalid_credentials
      {
        :login => '',
        :password => ''
      }
    end

    def valid_request_headers
      {
        'PAYSON-SECURITY-USERID' => 'sigge',
        'PAYSON-SECURITY-PASSWORD' => 'sigge123'
      }
    end

    def invalid_request_headers
      {
        'PAYSON-SECURITY-USERID' => nil,
        'PAYSON-SECURITY-PASSWORD' => nil
      }
    end

    # API URLs

    def authorization_url
      "#{AUTHORIZATION_URL}"
    end

    def payment_redirect_url(token = nil)
      "#{PAYMENT_REDIRECT_URL}?token=#{token}"
    end

    def payment_details_url
      "#{PAYMENT_DETAILS_URL}"
    end

    # TOKENS

    def valid_payment_token
      "4599093f-4675-477c-a1ac-734cbb1a9c16"
    end

    def invalid_payment_token
      "123ABC123ABC123ABC123ABC123ABC123ABC"
    end

    # REQUESTS

    def successful_authorization_request_body
      <<-REQUEST
      cancelUrl=http%3A%2F%2Ftest.smackaho.st%3A3000%2Ffailure&returnUrl=http%3A%2F%2Ftest.smackaho.st%3A3000%2Fsuccess&senderLastName=Grimfelt&receiverList.receiver(0).amount=1.0&memo=test&senderEmail=grimen%40example.com&custom=&receiverList.receiver(0).email=ashraf%40example.com&currencyCode=SEK&senderFirstName=Jonas
      REQUEST
    end

    # Same as success, but will be sent with bad credentials
    def failed_authorization_request_body
      <<-REQUEST
      cancelUrl=http%3A%2F%2Ftest.smackaho.st%3A3000%2Ffailure&returnUrl=http%3A%2F%2Ftest.smackaho.st%3A3000%2Fsuccess&senderLastName=Grimfelt&receiverList.receiver(0).amount=1.0&memo=test&senderEmail=grimen%40example.com&custom=&receiverList.receiver(0).email=ashraf%40example.com&currencyCode=SEK&senderFirstName=Jonas
      REQUEST
    end

    def successful_payment_details_request_body
      <<-RESPONSE
      token=5df04540-f103-4598-8567-5fc2e9fdcde6
      RESPONSE
    end

    def failed_payment_details_request_body
      <<-RESPONSE
      token=123ABC
      RESPONSE
    end

    # RESPONSES

    def failed_with_invalid_credentials_body
      <<-RESPONSE
      responseEnvelope.ack=FAILURE&responseEnvelope.timestamp=2010-07-29T12%3a28%3a46&responseEnvelope.version=1.0&errorList.error(0).errorId=520003&errorList.error(0).message=Authentication+failed%3b+Credentials+were+not+valid
      RESPONSE
    end

    def successful_authorization_response_body
      <<-RESPONSE
      responseEnvelope.ack=SUCCESS&responseEnvelope.timestamp=2010-07-27T16%3a57%3a27&responseEnvelope.version=1.0&TOKEN=5df04540-f103-4598-8567-5fc2e9fdcde6&responseEnvelope.correlatonId=133558
      RESPONSE
    end

    def failed_authorization_response_body
      <<-RESPONSE
      responseEnvelope.ack=FAILURE&responseEnvelope.timestamp=2010-07-27T15%3a36%3a00&responseEnvelope.version=1.0&errorList.error(0).errorId=520003&errorList.error(0).message=Authentication+failed%3b+Credentials+were+not+valid
      RESPONSE
    end

    def successful_payment_details_response_body
      <<-RESPONSE
      responseEnvelope.ack=SUCCESS&responseEnvelope.timestamp=2010-07-29T15%3a18%3a36&responseEnvelope.version=1.0&currencyCode=SEK&senderEmail=grimen%40gmail.com&custom=&correlationId=135372&purchaseId=3566124&status=COMPLETED&token=23c26dd2-1c27-48d1-abc2-40b8dcd004b9&receiverList.receiver(0).email=zmn.ashraf%40gmail.com&receiverList.receiver(0).amount=1.00
      RESPONSE
    end

    def failed_payment_details_response_body
      <<-RESPONSE
      responseEnvelope.ack=FAILURE&responseEnvelope.timestamp=2010-07-29T15%3a21%3a47&responseEnvelope.version=1.0
      RESPONSE
    end

    # For reference, for now.
    def failed_body
      %{
        responseEnvelope.ack=FAILURE&responseEnvelope.timestamp=2010-07-27T17%3a46%3a58&responseEnvelope.version=1.0&errorList.error(0).errorId=580028&errorList.error(0).message=A+URL+supplied+is+malformed&errorList.error(0).parameter=returnUrl&errorList.error(1).errorId=580029&errorList.error(1).message=A+required+parameter+was+not+provided&errorList.error(1).parameter=returnUrl&errorList.error(2).errorId=580028&errorList.error(2).message=A+URL+supplied+is+malformed&errorList.error(2).parameter=cancelUrl&errorList.error(3).errorId=580029&errorList.error(3).message=A+required+parameter+was+not+provided&errorList.error(3).parameter=cancelUrl&errorList.error(4).errorId=580029&errorList.error(4).message=A+required+parameter+was+not+provided&errorList.error(4).parameter=memo&errorList.error(5).errorId=580022&errorList.error(5).message=Invalid+parameter&errorList.error(5).parameter=memo&errorList.error(6).errorId=580022&errorList.error(6).message=Invalid+parameter&errorList.error(6).parameter=senderEmail&errorList.error(7).errorId=580029&errorList.error(7).message=A+required+parameter+was+not+provided&errorList.error(7).parameter=senderEmail&errorList.error(8).errorId=580029&errorList.error(8).message=A+required+parameter+was+not+provided&errorList.error(8).parameter=senderFirstname&errorList.error(9).errorId=580029&errorList.error(9).message=A+required+parameter+was+not+provided&errorList.error(9).parameter=senderLastname
      }
    end
end
