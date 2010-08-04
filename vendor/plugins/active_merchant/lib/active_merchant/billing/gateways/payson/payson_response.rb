module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaysonResponse < Response

      def initialize(body)
        body ||= ""
        @body = body.strip
        @params = self.parse(@body)
      end

      def success?
        status == 'SUCCESS'
      end

      def fail?
        status == 'FAILURE'
      end

      def test?
        false
      end

      def token
        @params['TOKEN']
      end

      def status
        @params['responseEnvelope.ack']
      end

      def params
        @params
      end

      def body
        @body
      end

      protected

        # Parse the response body into hash of params.
        def parse(body)
          return {} if body.blank?

          body.split('&').inject({}) do |memo, chunk|
            next if chunk.empty?
            key, value = chunk.split('=', 2)
            next if key.empty?
            value = value.nil? ? nil : CGI.unescape(value)
            memo[CGI.unescape(key)] = value
            memo
          end.stringify_keys
        end

    end
  end
end