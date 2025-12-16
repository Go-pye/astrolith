module RubyChartEngine
  module Calculations
    class Houses
      attr_reader :julian_day, :latitude, :longitude, :house_system

      def initialize(julian_day:, latitude:, longitude:, house_system: :placidus)
        @julian_day = julian_day
        @latitude = latitude
        @longitude = longitude
        @house_system = house_system
      end

      # Calculate house cusps and angles
      def calculate
        system_code = HOUSE_SYSTEMS[house_system] || 'P'

        # Call swe_houses - returns a flat array of 23 elements
        # [0-12]: house cusps (0 is unused, 1-12 are the 12 houses)
        # [13+]: ASCMC values (ascendant, MC, ARMC, vertex, etc.)
        result = Swe4r.swe_houses(julian_day, latitude, longitude, system_code)

        unless result.is_a?(Array)
          raise Error, "Unexpected swe_houses return type: #{result.class} - #{result.inspect}"
        end

        {
          cusps: extract_cusps(result),
          angles: extract_angles(result)
        }
      rescue StandardError => e
        raise Error, "Failed to calculate houses: #{e.message}\nResult type: #{result.class rescue 'unknown'}\nResult: #{result.inspect rescue 'uninspectable'}"
      end

      # Determine which house a longitude is in
      def house_for_longitude(longitude, cusps)
        # Normalize longitude
        longitude = normalize_degrees(longitude)

        # Return default if cusps is empty or invalid
        return 1 if cusps.nil? || cusps.empty? || cusps.length < 12

        # Find the house
        12.times do |i|
          cusp_start = cusps[i]
          cusp_end = cusps[(i + 1) % 12]

          # Skip if cusps are nil
          next if cusp_start.nil? || cusp_end.nil?

          # Handle wrapping around 0 degrees
          if cusp_start > cusp_end
            return i + 1 if longitude >= cusp_start || longitude < cusp_end
          else
            return i + 1 if longitude >= cusp_start && longitude < cusp_end
          end
        end

        1 # Default to first house
      end

      private

      def extract_cusps(result_array)
        # swe_houses returns a flat array where:
        # [0-12]: house cusps (0 is unused, 1-12 are the 12 houses)
        # We want indices 1-12
        return [] unless result_array.is_a?(Array) && result_array.length >= 13

        result_array[1..12]
      end

      def extract_angles(result_array)
        # swe_houses returns a flat array where:
        # [13]: Ascendant
        # [14]: MC (Midheaven)
        # [15]: ARMC
        # [16]: Vertex
        # [17-22]: Other values
        return {} unless result_array.is_a?(Array) && result_array.length >= 17

        {
          ascendant: result_array[13],
          midheaven: result_array[14],
          descendant: normalize_degrees(result_array[13] + 180),
          imum_coeli: normalize_degrees(result_array[14] + 180),
          vertex: result_array[16]
        }
      end

      def normalize_degrees(degrees)
        degrees = degrees % 360
        degrees += 360 if degrees < 0
        degrees
      end
    end
  end
end
