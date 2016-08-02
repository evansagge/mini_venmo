module MiniVenmo
  class Commands
    class Add
      attr_reader :name, :card_number

      def initialize(name, card_number)
        @name = name
        @card_number = card_number
      end

      def run
        user.credit_card = MiniVenmo::Models::CreditCard.new(card_number)
      end

      private

      def user
        @user ||= MiniVenmo::Models::User.records[name]
      end
    end
  end
end
