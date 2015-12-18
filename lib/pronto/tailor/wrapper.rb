require 'open3'

module Pronto
  module Tailor
    class Wrapper
      def initialize(patch)
        @patch = patch
      end

      def lint
        return [] if @patch.nil?
        path = @patch.new_file_full_path.to_s
        params = nil
        stdout, stderr, _status = Open3.capture3("tailor \"#{path}\" #{params}")
        puts "WARN: pronto-tailor: #{stderr}" if stderr && stderr.size > 0
        return [] if stdout.nil? || stdout.size == 0
        JSON.parse(stdout)
      rescue => e
        puts "ERROR: pronto-tailor failed to process a diff: #{e}"
        []
      end
    end
  end
end
