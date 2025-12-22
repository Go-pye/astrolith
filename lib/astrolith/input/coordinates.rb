module Astrolith
  module Input
    class Coordinates
      attr_reader :latitude, :longitude

      # Parse coordinates from various formats:
      # - Decimal degrees: { lat: 32.7157, lon: -117.1611 }
      # - Standard text: { lat: '32n43', lon: '117w10' }
      # - Mixed: { lat: 32.7157, lon: '117w10' }
      def initialize(lat:, lon:)
        @latitude = parse_coordinate(lat, :lat)
        @longitude = parse_coordinate(lon, :lon)
      end

      private

      def parse_coordinate(value, type)
        return value.to_f if value.is_a?(Numeric)
        return value.to_f if value.is_a?(String) && value.match?(/^-?\d+\.?\d*$/)

        # Parse standard text format like '32n43' or '117w10'
        parse_standard_text(value, type)
      end

      def parse_standard_text(value, type)
        # Match patterns like: 32n43, 32N43, 32n43'30", etc.
        match = value.match(/(\d+)([nsewNSEW])(\d+)?(?:'(\d+)")?/)

        raise Error, "Invalid coordinate format: #{value}" unless match

        degrees = match[1].to_i
        direction = match[2].downcase
        minutes = match[3]&.to_i || 0
        seconds = match[4]&.to_i || 0

        decimal = degrees + (minutes / 60.0) + (seconds / 3600.0)

        # Apply sign based on direction
        if type == :lat
          decimal = -decimal if direction == 's'
        else
          decimal = -decimal if direction == 'w'
        end

        decimal
      end
    end
  end
end
