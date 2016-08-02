module MiniVenmo
  module Models
    Payment = Struct.new(:actor, :target, :amount, :note) do
      def numeric_amount
        amount.delete('$').to_f
      end
    end
  end
end
