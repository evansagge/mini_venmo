module MiniVenmo
  class Commands
    class Pay
      attr_reader :actor_name, :target_name, :amount, :note

      def initialize(actor_name, target_name, amount, note)
        @actor_name = actor_name
        @target_name = target_name
        @amount = amount
        @note = note
      end

      def run
        payment = MiniVenmo::Models::Payment.new(actor, target, amount, note)
        actor.payments << payment
        target.payments << payment
      end

      private

      def actor
        @actor ||= MiniVenmo::Models::User.records[actor_name]
      end

      def target
        @target ||= MiniVenmo::Models::User.records[target_name]
      end
    end
  end
end
