module MiniVenmo
  module Models
    Payment = Struct.new(:actor, :target, :amount, :note) do
      def numeric_amount
        amount.delete('$').to_f
      end

      def actor_name
        actor.name
      end

      def target_name
        target.name
      end
    end
  end
end
