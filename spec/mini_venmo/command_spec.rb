require 'spec_helper'

RSpec.describe MiniVenmo::Command do
  let(:instance) { described_class.new(input) }
  let(:input) { 'user Thomas' }

  describe '#run' do
    subject { instance.run }

    it 'pipes the command to the proper Commands object' do
      command_double = double(MiniVenmo::Commands::User, run: true)
      expect(MiniVenmo::Commands::User).to receive(:new).with('Thomas').and_return(command_double)
      expect(command_double).to receive(:run)
      subject
    end

    context 'if there is no class in the Commands module matching the first argument' do
      let(:input) { 'foobar' }

      it 'displays an error' do
        expect { subject }.to output(/ERROR: command not recognized/).to_stdout
      end
    end

    context 'if there are more than the allowed number of arguments for the command' do
      let(:input) { 'user Thomas 12345' }

      it 'displays an error' do
        expect { subject }.to output(/ERROR: invalid arguments/).to_stdout
      end
    end
  end
end
