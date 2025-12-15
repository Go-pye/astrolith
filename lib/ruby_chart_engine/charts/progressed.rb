require_relative 'base_chart'

module RubyChartEngine
  module Charts
    class Progressed < BaseChart
      attr_reader :natal_datetime, :progression_date

      # Secondary Progressed chart
      # Uses "a day for a year" progression
      def initialize(natal_datetime:, progression_date:, latitude:, longitude:, timezone: 'UTC', house_system: :placidus)
        @natal_datetime = natal_datetime
        @progression_date = progression_date

        # Calculate progressed datetime
        progressed_datetime = calculate_progressed_datetime

        # Initialize with progressed datetime
        super(
          datetime: progressed_datetime,
          latitude: latitude,
          longitude: longitude,
          timezone: timezone,
          house_system: house_system
        )
      end

      def to_hash
        super.merge(
          natal_datetime: @natal_datetime.to_s,
          progression_date: @progression_date.to_s,
          chart_type: 'progressed'
        )
      end

      private

      def calculate_progressed_datetime
        natal_dt = Input::DateTime.new(@natal_datetime)
        prog_dt = Input::DateTime.new(@progression_date)

        # Calculate days between natal and progression date
        natal_date = natal_dt.datetime
        progression_date = prog_dt.datetime

        days_difference = (progression_date - natal_date).to_i

        # Add the same number of days to natal datetime
        # (Secondary progression: 1 day = 1 year)
        progressed = natal_date + days_difference

        progressed
      end
    end
  end
end
