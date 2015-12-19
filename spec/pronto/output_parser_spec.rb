require 'spec_helper'
require 'pronto/tailor/output_parser'

RSpec.describe Pronto::Tailor::OutputParser do
  let(:parser) { described_class.new(file, output) }
  let(:file) { '/tmp/work/ios/View Controllers/TableViewController.swift' }
  let(:output) { '/tmp/work/ios/View Controllers/TableViewController.swift:122:06: warning: [function-whitespace] Function should have at least one blank line after it' }

  describe '#parse' do
    subject { parser.parse }

    it 'parses output' do
      expect(subject).to eq([
        'line' => 122,
        'level' => 'warning',
        'rule' => 'function-whitespace',
        'message' => 'Function should have at least one blank line after it'
      ])
    end

    context 'no column present' do
      let(:output) { '/tmp/work/ios/View Controllers/TableViewController.swift:122:    warning: [function-whitespace] Function should have at least one blank line after it' }

      it 'parses output' do
        expect(subject).to eq([
          'line' => 122,
          'level' => 'warning',
          'rule' => 'function-whitespace',
          'message' => 'Function should have at least one blank line after it'
        ])
      end
    end
  end
end
