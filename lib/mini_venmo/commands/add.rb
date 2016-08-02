require 'luhn'

module MiniVenmo
  class Commands
    class Add
      attr_reader :name, :card_number

      def initialize(name, card_number)
        @name = name
        @card_number = card_number
      end

      def run
        validate!
        new_credit_card = MiniVenmo::Models::CreditCard.new(card_number, user)
        MiniVenmo::Store.credit_cards[card_number] = new_credit_card
        user.credit_card = new_credit_card
        nil
      end

      private

      def user
        @user ||= MiniVenmo::Store.users[name]
      end

      def validate!
        validate_user!
        validate_user_credit_card!
        validate_unique_credit_card!
        validate_credit_card!
      end

      def validate_user!
        raise Error.new('invalid arguments') if user.nil?
      end

      def validate_user_credit_card!
        raise Error.new('this user already has a valid credit card') unless user.credit_card.nil?
      end

      def validate_unique_credit_card!
        return if MiniVenmo::Store.credit_cards[card_number].nil?
        raise Error.new('that card has already been added by another user, reported for fraud!')
      end

      def validate_credit_card!
        raise Error.new('this card is invalid') unless Luhn.valid?(card_number)
      end
    end
  end
end
