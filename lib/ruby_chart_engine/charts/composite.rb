require_relative 'base_chart'

module RubyChartEngine
  module Charts
    class Composite < BaseChart
      attr_reader :chart1, :chart2

      # Composite chart - midpoint chart between two natal charts
      def initialize(chart1_params:, chart2_params:, house_system: :placidus)
        # Create the two base charts
        @chart1 = Natal.new(**chart1_params)
        @chart2 = Natal.new(**chart2_params)

        # Calculate composite datetime and location
        composite_datetime = calculate_midpoint_datetime
        composite_coords = calculate_midpoint_coordinates

        # Initialize with composite parameters
        super(
          datetime: composite_datetime,
          latitude: composite_coords[:latitude],
          longitude: composite_coords[:longitude],
          timezone: chart1_params[:timezone] || 'UTC',
          house_system: house_system
        )
      end

      def to_hash
        super.merge(
          chart_type: 'composite',
          chart1_metadata: @chart1.to_hash[:metadata],
          chart2_metadata: @chart2.to_hash[:metadata]
        )
      end

      private

      def calculate_midpoint_datetime
        # Calculate midpoint between two datetimes
        jd1 = @chart1.julian_day
        jd2 = @chart2.julian_day

        midpoint_jd = (jd1 + jd2) / 2.0

        # Convert back to datetime
        result = Swe4r.swe_revjul(midpoint_jd, Swe4r::SE_GREG_CAL)

        ::DateTime.new(
          result[:year],
          result[:month],
          result[:day],
          result[:hour].to_i,
          ((result[:hour] % 1) * 60).to_i,
          0
        )
      end

      def calculate_midpoint_coordinates
        lat1 = @chart1.coordinates.latitude
        lon1 = @chart1.coordinates.longitude
        lat2 = @chart2.coordinates.latitude
        lon2 = @chart2.coordinates.longitude

        # Simple midpoint calculation
        # Note: This doesn't account for the spherical nature of Earth
        # For a more accurate calculation, use great circle midpoint
        {
          latitude: (lat1 + lat2) / 2.0,
          longitude: calculate_longitude_midpoint(lon1, lon2)
        }
      end

      def calculate_longitude_midpoint(lon1, lon2)
        # Handle date line crossing
        diff = (lon2 - lon1).abs

        if diff > 180
          # Crosses date line - take the "other" midpoint
          midpoint = (lon1 + lon2 + 360) / 2.0
          midpoint -= 360 if midpoint > 180
        else
          midpoint = (lon1 + lon2) / 2.0
        end

        midpoint
      end
    end
  end
end
