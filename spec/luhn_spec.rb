require 'spec_helper'

RSpec.describe Luhn do
  shared_examples 'a Luhn string' do |string, valid|
    describe '.valid?' do
      subject { described_class.valid?(value) }

      context "given a string #{string.inspect}" do
        let(:value) { string }

        specify { expect(subject).to eq(valid) }
      end
    end
  end

  it_should_behave_like 'a Luhn string', '346931287230311', true  # AMEX
  it_should_behave_like 'a Luhn string', '30293736305645', true   # Diners Club
  it_should_behave_like 'a Luhn string', '6011953664660606', true # Discover
  it_should_behave_like 'a Luhn string', '3088604077728887', true # JCB
  it_should_behave_like 'a Luhn string', '210022130182199', true  # JCB-15
  it_should_behave_like 'a Luhn string', '5593998754497458', true # MasterCard
  it_should_behave_like 'a Luhn string', '4556118903576221', true # VISA
  it_should_behave_like 'a Luhn string', '4532292775481', true    # VISA-13
  it_should_behave_like 'a Luhn string', '4111111111111111', true
  it_should_behave_like 'a Luhn string', '5454545454545454', true
  it_should_behave_like 'a Luhn string', '1234567890123456', false
  it_should_behave_like 'a Luhn string', '323232', false
  it_should_behave_like 'a Luhn string', 'a411111111111111', false
  it_should_behave_like 'a Luhn string', 'abcdefgh', false
end
