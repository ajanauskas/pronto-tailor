require 'pronto'
require 'pronto/tailor/version'
require 'pronto/tailor/wrapper'

module Pronto
  class Tailor < Runner
    def initialize
    end

    def run(patches, _)
      return [] unless patches
      patches.select { |p| p.additions > 0 }
        .select { |p| swift_file?(p.new_file_full_path) }
        .map { |p| inspect(p) }
        .flatten
        .compact
    end

    private

    def inspect(patch)
      offences = Tailor::Wrapper.new(patch).lint
      offences.map do |_file_path, violations|
        violations.map do |offence|
          patch.added_lines.select { |line| line.new_lineno == offence['line'] }
            .map { |line| new_message(offence, line) }
        end
      end
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      level = :warning
      Message.new(path, line, level, offence['message'])
    end

    def swift_file?(path)
      %w(.swift).include?(File.extname(path))
    end
  end
end
