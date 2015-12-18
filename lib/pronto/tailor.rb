require 'pronto'
require 'pronto/tailor/version'
require 'pronto/tailor/wrapper'

module Pronto
  class TailorRunner < Runner
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
      messages = []
      offences.each do |offence|
        messages += patch
          .added_lines
          .select { |line| line.new_lineno == offence['line'] }
          .map { |line| new_message(offence, line) }
      end
      messages.compact
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      Message.new(path, line, offence['level'].to_sym, offence['message'])
    end

    def swift_file?(path)
      %w(.swift).include?(File.extname(path))
    end
  end
end
