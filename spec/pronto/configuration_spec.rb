require 'spec_helper'
require 'pronto/tailor/configuration'

RSpec.describe Pronto::Tailor::Configuration do
  let(:configuration) { described_class.new(params) }
  let(:params) { { } }
  let(:file) { '/tmp/somefile.swift' }

  describe '#command_line_for_file' do
    subject { configuration.command_line_for_file(file) }

    it 'makes tailor command line' do
      expect(subject).to eq "tailor \"#{file}\" "
    end

    context 'runner specified' do
      let(:params) { { 'PRONTO_TAILOR_TAILOR_PATH' => '/usr/bin/tailor' } }

      it 'makes tailor command line' do
        expect(subject).to eq "/usr/bin/tailor \"#{file}\" "
      end
    end

    context 'except rule specified' do
      let(:params) { { 'PRONTO_TAILOR_EXCEPT_RULE' => 'trailing-whitespace' } }

      it 'makes tailor command line' do
        expect(subject).to eq "tailor \"#{file}\" --except=trailing-whitespace"
      end
    end

    context 'config file specified' do
      let(:params) { { 'PRONTO_TAILOR_CONFIG_FILE' => '/tmp/config.yml' } }

      it 'makes tailor command line' do
        expect(subject).to eq "tailor \"#{file}\" --config=/tmp/config.yml"
      end
    end
  end
end
