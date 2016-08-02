module MiniVenmo
  class Commands
    class Pay
      VALID_AMOUNT_FORMAT = /^\$\d+.\d{2}$/
      attr_reader :actor_name, :target_name, :amount, :note

      def initialize(actor_name, target_name, amount, *note)
        @actor_name = actor_name
        @target_name = target_name
        @amount = amount
        @note = note.join(' ')
      end

      def run
        validate!

        actor.payments << payment
        target.payments << payment
        target.balance += payment.numeric_amount
      end

      private

      def actor
        @actor ||= MiniVenmo::Store.users[actor_name]
      end

      def target
        @target ||= MiniVenmo::Store.users[target_name]
      end

      def payment
        @payment ||= MiniVenmo::Models::Payment.new(actor, target, amount, note)
      end

      def validate!
        validate_actor!
        validate_target!
        validate_amount!
        validate_distinct_actor_and_target!
        validate_actor_credit_card!
      end

      def validate_actor!
        raise Error.new('invalid arguments') if actor.nil?
      end

      def validate_target!
        raise Error.new('invalid arguments') if target.nil?
      end

      def validate_amount!
        raise Error.new('invalid arguments') unless amount =~ VALID_AMOUNT_FORMAT
      end

      def validate_distinct_actor_and_target!
        raise Error.new('users cannot pay themselves') if actor == target
      end

      def validate_actor_credit_card!
        raise Error.new('this user does not have a credit card') if actor.credit_card.nil?
      end
    end
  end
end
