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
        params = '--except=trailing-whitespace'
        stdout, stderr, _status = Open3.capture3("tailor \"#{path}\" #{params}")
        puts "WARN: pronto-tailor: #{stderr}" if stderr && stderr.size > 0
        return [] if stdout.nil? || stdout.size == 0
        out
      rescue => e
        puts "ERROR: pronto-tailor failed to process a diff: #{e}"
        []
      end

      def parse_output_in_file(path, output)
        output.lines.map do |line|
          next unless line.start_with?(path)
          line_parts = line.split(':')
          offence_in_line = line_parts[1]
          if line_parts[2].to_i == 0
            offence_level = line_parts[2].strip
          else
            offence_level = line_parts[3].strip
          end
          offence_rule = line[/\[.*?\]/].gsub('[', '').gsub(']', '')
          index_of_offence_rule = line.index(offence_rule)
          offence_message = line[index_of_offence_rule + offence_rule.size + 2..line.size]
          {
            'line' => offence_in_line.to_i,
            'level' => offence_level,
            'rule' => offence_rule,
            'message' => offence_message
          }
        end.compact
      end
    end
  end
end
