require_relative 'base_chart'

module RubyChartEngine
  module Charts
    class SolarReturn < BaseChart
      attr_reader :natal_sun_longitude

      # Solar Return chart for a specific year
      # Calculated for the moment the Sun returns to its natal position
      def initialize(natal_datetime:, return_year:, latitude:, longitude:, timezone: 'UTC', house_system: :placidus)
        # Get natal Sun position
        natal_chart_temp = Natal.new(
          datetime: natal_datetime,
          latitude: latitude,
          longitude: longitude,
          timezone: timezone
        )
        @natal_sun_longitude = natal_chart_temp.planets[:sun][:longitude]

        # Find the moment when Sun returns to natal position in the return year
        return_datetime = find_solar_return_time(natal_datetime, return_year, timezone)

        # Initialize with the solar return datetime
        super(
          datetime: return_datetime,
          latitude: latitude,
          longitude: longitude,
          timezone: timezone,
          house_system: house_system
        )
      end

      def to_hash
        super.merge(
          natal_sun_longitude: @natal_sun_longitude,
          chart_type: 'solar_return'
        )
      end

      private

      def find_solar_return_time(natal_datetime, return_year, timezone)
        # Parse natal datetime
        natal_dt = Input::DateTime.new(natal_datetime)

        # Start with birthday in the return year
        search_date = ::DateTime.new(
          return_year,
          natal_dt.month,
          natal_dt.day,
          natal_dt.hour,
          natal_dt.minute,
          natal_dt.second
        )

        # Binary search to find exact moment of solar return
        # This is a simplified implementation
        best_date = search_date
        min_diff = Float::INFINITY

        # Search in a 48-hour window around the birthday
        (-24..24).each do |hour_offset|
          test_date = search_date + (hour_offset / 24.0)
          test_dt = Input::DateTime.new(test_date)
          tz = Input::Timezone.new(timezone, test_date)
          jd = test_dt.to_julian_day(tz.offset_hours)

          # Calculate Sun position
          pos_calc = Calculations::Positions.new(
            julian_day: jd,
            latitude: 0,
            longitude: 0
          )
          sun_pos = pos_calc.calculate_planet(PLANETS[:sun])

          # Calculate difference from natal Sun
          diff = (sun_pos[:longitude] - @natal_sun_longitude).abs
          diff = 360 - diff if diff > 180

          if diff < min_diff
            min_diff = diff
            best_date = test_date
          end
        end

        best_date
      end
    end
  end
end
