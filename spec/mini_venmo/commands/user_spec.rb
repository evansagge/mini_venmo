require 'spec_helper'

RSpec.describe MiniVenmo::Commands::User do
  let(:instance) { described_class.new(name) }

  let(:name) { 'Thomas' }

  describe '#run' do
    subject { instance.run }

    it 'creates a new User with a balance of $0' do
      expect { subject }.to change { MiniVenmo::Models::User.records }.from({}).to('Thomas' => MiniVenmo::Models::User.new('Thomas'))
      expect(MiniVenmo::Models::User.records['Thomas'].balance).to eq(0.00)
    end

    context 'if name contains characters other than alphanumeric characters, underscores and dashes' do
      let(:name) { '!invalidname123' }

      it 'raises an error' do
        expect { subject }.to raise_error(MiniVenmo::Errors::InvalidArgumentError)
      end
    end

    context 'if name is shorter than 4 characters' do
      let(:name) { 'Joe' }

      it 'raises an error' do
        expect { subject }.to raise_error(MiniVenmo::Errors::InvalidArgumentError)
      end
    end

    context 'if name is longer than 15 characters' do
      let(:name) { 'Evan Vidal Sagge' }

      it 'raises an error' do
        expect { subject }.to raise_error(MiniVenmo::Errors::InvalidArgumentError)
      end
    end
  end
end
