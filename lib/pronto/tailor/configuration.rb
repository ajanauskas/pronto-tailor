module Pronto
  module Tailor
    CONFIGURATION_PREFIX = 'PRONTO_TAILOR_'.freeze
    TAILOR_RUNNER = CONFIGURATION_PREFIX + 'TAILOR_PATH'
    EXCEPT_RULE = CONFIGURATION_PREFIX + 'EXCEPT_RULE'
    CONFIG_FILE = CONFIGURATION_PREFIX + 'CONFIG_FILE'

    class Configuration
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def command_line_for_file(file)
        params = [
          except_rule,
          config_file
        ].compact.join(' ')

        "#{runner} \"#{file}\" #{params}"
      end

      private

      def runner
        params[TAILOR_RUNNER] || 'tailor'
      end

      def except_rule
        "--except=#{params[EXCEPT_RULE]}" if params[EXCEPT_RULE]
      end

      def config_file
        "--config=#{params[CONFIG_FILE]}" if params[CONFIG_FILE]
      end
    end
  end
end
