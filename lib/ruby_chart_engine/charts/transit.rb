require_relative 'base_chart'

module RubyChartEngine
  module Charts
    class Transit < BaseChart
      attr_reader :natal_chart, :transit_aspects

      # Transit chart - current planetary positions compared to natal chart
      def initialize(natal_chart_params:, transit_datetime:, house_system: :placidus)
        # Create natal chart if not provided
        @natal_chart = if natal_chart_params.is_a?(Natal)
                         natal_chart_params
                       else
                         Natal.new(**natal_chart_params)
                       end

        # Use natal chart location for transit chart
        # (transits are typically calculated for the natal location)
        super(
          datetime: transit_datetime,
          latitude: @natal_chart.coordinates.latitude,
          longitude: @natal_chart.coordinates.longitude,
          timezone: natal_chart_params[:timezone] || 'UTC',
          house_system: house_system
        )

        # Calculate aspects between transit planets and natal planets
        calculate_transit_aspects!
      end

      def to_hash
        super.merge(
          chart_type: 'transit',
          natal_chart_metadata: @natal_chart.to_hash[:metadata],
          transit_aspects: @transit_aspects
        )
      end

      private

      def calculate_transit_aspects!
        # Calculate aspects from transit planets to natal planets
        @transit_aspects = Calculations::Aspects.calculate(
          @planets,
          @natal_chart.planets
        )

        # Also calculate aspects from natal to transit (for completeness)
        reverse_aspects = Calculations::Aspects.calculate(
          @natal_chart.planets,
          @planets
        )

        # Combine and deduplicate
        @transit_aspects = (@transit_aspects + reverse_aspects).uniq do |aspect|
          [
            [aspect[:planet1], aspect[:planet2]].sort,
            aspect[:type]
          ]
        end
      end
    end
  end
end
