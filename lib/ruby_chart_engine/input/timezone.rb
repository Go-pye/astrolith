require 'tzinfo'

module RubyChartEngine
  module Input
    class Timezone
      attr_reader :timezone, :offset

      # Parse timezone from various formats:
      # - TZInfo timezone identifier: "America/Los_Angeles"
      # - UTC offset: "+05:30" or -8
      # - TZInfo::Timezone object
      def initialize(timezone, datetime = nil)
        @timezone = parse_timezone(timezone)
        @datetime = datetime
        @offset = calculate_offset
      end

      # Get offset in hours
      def offset_hours
        @offset / 3600.0
      end

      private

      def parse_timezone(value)
        case value
        when TZInfo::Timezone
          value
        when String
          if value.match?(/^[+-]?\d{1,2}:?\d{0,2}$/)
            # UTC offset format
            parse_utc_offset(value)
          else
            # TZInfo identifier
            TZInfo::Timezone.get(value)
          end
        when Numeric
          # Hours offset
          parse_utc_offset(value)
        else
          raise Error, "Invalid timezone format: #{value.class}"
        end
      end

      def parse_utc_offset(value)
        # Convert to seconds offset
        case value
        when String
          sign = value.start_with?('-') ? -1 : 1
          parts = value.gsub(/^[+-]/, '').split(':')
          hours = parts[0].to_i
          minutes = parts[1]&.to_i || 0
          offset_seconds = sign * (hours * 3600 + minutes * 60)
        when Numeric
          offset_seconds = value * 3600
        end

        # Create a timezone with fixed offset
        TZInfo::Timezone.get('UTC').tap do |tz|
          @offset = offset_seconds
        end
      end

      def calculate_offset
        return @offset if @offset

        if @timezone.is_a?(TZInfo::Timezone) && @datetime
          period = @timezone.period_for_local(@datetime)
          period.utc_total_offset
        else
          0
        end
      end
    end
  end
end
