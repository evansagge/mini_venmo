require 'spec_helper'

RSpec.describe MiniVenmo::Commands::User do
  let(:instance) { described_class.new(name) }

  let(:name) { 'Thomas' }

  describe '#run' do
    subject { instance.run }

    it 'creates a new User with a balance of $0' do
      expect { subject }.to change { MiniVenmo::Store.users }.from({}).to('Thomas' => MiniVenmo::Models::User.new('Thomas'))
      expect(MiniVenmo::Store.users['Thomas'].balance).to eq(0.00)
    end

    context 'validations' do
      context 'if name contains characters other than alphanumeric characters, underscores and dashes' do
        let(:name) { '!invalidname123' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid arguments')
        end
      end

      context 'if name is shorter than 4 characters' do
        let(:name) { 'Joe' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid arguments')
        end
      end

      context 'if name is longer than 15 characters' do
        let(:name) { 'Evan Vidal Sagge' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid arguments')
        end
      end
    end
  end
end
