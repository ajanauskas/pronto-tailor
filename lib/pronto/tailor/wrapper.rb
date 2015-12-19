require 'open3'
require_relative 'configuration'
require_relative 'output_parser'

module Pronto
  module Tailor
    class Wrapper
      attr_reader :patch

      def initialize(patch)
        @patch = patch
      end

      def lint
        return [] if patch.nil?
        configuration = Configuration.new(ENV)
        path = patch.new_file_full_path.to_s
        stdout, stderr, _status = Open3.capture3(configuration.command_line_for_file(path))
        puts "WARN: pronto-tailor: #{stderr}" if stderr && stderr.size > 0
        return [] if stdout.nil? || stdout.size == 0
        OutputParser.new(path, stdout).parse
      rescue => e
        puts "ERROR: pronto-tailor failed to process a diff: #{e}"
        []
      end
    end
  end
end
