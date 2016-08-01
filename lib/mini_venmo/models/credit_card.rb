module MiniVenmo
  module Models
    class CreditCard
      attr_reader :number

      def initialize(number)
        @number = number
      end
    end
  end
end
