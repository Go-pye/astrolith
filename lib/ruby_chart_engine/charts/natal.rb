require_relative 'base_chart'

module RubyChartEngine
  module Charts
    class Natal < BaseChart
      # Natal chart is the base chart type
      # Additional natal-specific methods can be added here

      def moon_phase
        sun_lon = @planets[:sun][:longitude]
        moon_lon = @planets[:moon][:longitude]

        phase_angle = (moon_lon - sun_lon) % 360

        case phase_angle
        when 0..45
          'New Moon'
        when 45..90
          'Waxing Crescent'
        when 90..135
          'First Quarter'
        when 135..180
          'Waxing Gibbous'
        when 180..225
          'Full Moon'
        when 225..270
          'Waning Gibbous'
        when 270..315
          'Last Quarter'
        when 315..360
          'Waning Crescent'
        end
      end

      def chart_shape
        # Analyze planetary distribution to determine chart shape
        # This is a simplified implementation
        longitudes = @planets.select { |k, _| PLANETS.keys.include?(k) }
                             .map { |_, v| v[:longitude] }
                             .sort

        return 'splash' if longitudes.empty?

        # Calculate the largest gap between consecutive planets
        gaps = []
        longitudes.each_with_index do |lon, i|
          next_lon = longitudes[(i + 1) % longitudes.length]
          gap = next_lon > lon ? next_lon - lon : (360 - lon) + next_lon
          gaps << gap
        end

        max_gap = gaps.max
        occupied_arc = 360 - max_gap

        case
        when max_gap > 240
          'bundle'
        when occupied_arc <= 120
          'bundle'
        when occupied_arc <= 180
          'bowl'
        when occupied_arc <= 240
          'bucket'
        when gaps.all? { |g| g > 20 && g < 60 }
          'splay'
        else
          'splash'
        end
      end

      def to_hash
        super.merge(
          moon_phase: moon_phase,
          chart_shape: chart_shape
        )
      end
    end
  end
end
