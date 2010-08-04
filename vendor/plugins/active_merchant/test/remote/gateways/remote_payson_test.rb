require 'test_helper'

class RemotePaysonTest < Test::Unit::TestCase

  # TODO: Need a test account.
  def setup
    # @gateway = PaysonGateway.new(fixtures(:payson))
    #
    # @amount = 100.0
    #
    # @options = {
    #   :order_id => '1',
    #   :billing_address => address,
    #   :description => 'Store Purchase'
    # }
  end

  # TODO: Need a test account.
  def test_successful_purchase
    # Example:
    # assert response = @gateway.purchase(@amount, @credit_card, @options)
    # assert_success response
    # assert_equal 'REPLACE WITH SUCCESS MESSAGE', response.message
  end

  # TODO: Need a test account.
  def test_unsuccessful_purchase
    # Example:
    # assert response = @gateway.purchase(@amount, @declined_card, @options)
    # assert_failure response
    # assert_equal 'REPLACE WITH FAILED PURCHASE MESSAGE', response.message
  end

  # TODO: Need a test account.
  def test_authorize_and_capture
    # Example:
    # amount = @amount
    # assert auth = @gateway.authorize(amount, @credit_card, @options)
    # assert_success auth
    # assert_equal 'Success', auth.message
    # assert auth.authorization
    # assert capture = @gateway.capture(amount, auth.authorization)
    # assert_success capture
  end

  # TODO: Need a test account.
  def test_failed_capture
    # Example:
    # assert response = @gateway.capture(@amount, '')
    # assert_failure response
    # assert_equal 'REPLACE WITH GATEWAY FAILURE MESSAGE', response.message
  end

  # TODO: Need a test account.
  def test_invalid_login
    # Example:
    # gateway = PaysonGateway.new(
    #             :login => '',
    #             :password => ''
    #           )
    # assert response = gateway.purchase(@amount, @credit_card, @options)
    # assert_failure response
    # assert_equal 'REPLACE WITH FAILURE MESSAGE', response.message
  end

end
