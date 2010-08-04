module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaysonPaymentDetailsResponse < PaysonResponse

      # The status of the payment.
      #
      #   CREATED - The payment request was received; funds will be transferred once approval is received
      #   PENDING – The sender has a transaction pending
      #   PROCESSING - The payment is in progress; check again later
      #   COMPLETED - The sender's transaction has completed
      #   INCOMPLETE - Some transfers succeeded and some failed for a parallel payment
      #   ERROR - The payment failed and all attempted transfers failed or all completed transfers were successfully reversed
      #   EXPIRED - A payment requiring approval was not executed within 3 hours
      #   REVERSALERROR – One or more transfers failed when attempting to reverse a payment
      #

      STATUSES = ['CREATED', 'PENDING', 'PROCESSING', 'COMPLETED', 'INCOMPLETE', 'ERROR', 'EXPIRED', 'REVERSALERROR'].freeze

      STATUSES.each do |status|
        define_method("#{status.downcase}?") do
          self.send(:params).send(:[], 'status') == status.to_s
        end
      end

    end
  end
end