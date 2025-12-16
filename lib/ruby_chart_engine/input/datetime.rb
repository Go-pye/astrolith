require 'time'

module RubyChartEngine
  module Input
    class DateTime
      attr_reader :year, :month, :day, :hour, :minute, :second, :datetime

      # Parse datetime from various formats:
      # - Ruby DateTime/Time object
      # - ISO 8601 string: "2024-03-15T14:30:00"
      # - Hash: { year: 2024, month: 3, day: 15, hour: 14, minute: 30 }
      def initialize(datetime)
        @datetime = parse_datetime(datetime)
        @year = @datetime.year
        @month = @datetime.month
        @day = @datetime.day
        @hour = @datetime.hour
        @minute = @datetime.min
        @second = @datetime.sec
      end

      # Convert to Julian Day Number for Swiss Ephemeris
      def to_julian_day(timezone_offset = 0)
        # Adjust for timezone offset (in hours)
        adjusted_time = @datetime - (timezone_offset * 3600)

        # Use Swiss Ephemeris to calculate Julian Day
        # swe_julday takes 4 arguments: year, month, day, hour (as decimal)
        Swe4r.swe_julday(
          adjusted_time.year,
          adjusted_time.month,
          adjusted_time.day,
          adjusted_time.hour + (adjusted_time.min / 60.0) + (adjusted_time.sec / 3600.0)
        )
      end

      private

      def parse_datetime(value)
        case value
        when ::DateTime, ::Time
          value.to_datetime
        when String
          ::DateTime.parse(value)
        when Hash
          validate_datetime_hash!(value)
          ::DateTime.new(
            value[:year],
            value[:month],
            value[:day],
            value[:hour] || 0,
            value[:minute] || 0,
            value[:second] || 0
          )
        else
          raise Error, "Invalid datetime format: #{value.class}"
        end
      end

      def validate_datetime_hash!(hash)
        required = [:year, :month, :day]
        missing = required - hash.keys

        raise Error, "Missing required datetime fields: #{missing.join(', ')}" if missing.any?
      end
    end
  end
end
