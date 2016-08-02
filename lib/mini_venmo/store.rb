require 'singleton'

module MiniVenmo
  module Store
    module_function

    class << self
      attr_accessor :users, :credit_cards
    end

    def initialize
      self.users = {}
      self.credit_cards = {}
    end
  end
end
