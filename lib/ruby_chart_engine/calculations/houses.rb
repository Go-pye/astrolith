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

        result = Swe4r.swe_houses(julian_day, latitude, longitude, system_code)

        {
          cusps: extract_cusps(result[:cusps]),
          angles: extract_angles(result[:ascmc])
        }
      rescue => e
        raise Error, "Failed to calculate houses: #{e.message}"
      end

      # Determine which house a longitude is in
      def house_for_longitude(longitude, cusps)
        # Normalize longitude
        longitude = normalize_degrees(longitude)

        # Find the house
        12.times do |i|
          cusp_start = cusps[i]
          cusp_end = cusps[(i + 1) % 12]

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

      def extract_cusps(cusps_array)
        # Swiss Ephemeris returns 13 cusps (1-12, with 1 repeated)
        # We want houses 1-12
        cusps_array[1..12]
      end

      def extract_angles(ascmc_array)
        # ASCMC array contains: [0]=Ascendant, [1]=MC, [2]=ARMC, [3]=Vertex, etc.
        {
          ascendant: ascmc_array[0],
          midheaven: ascmc_array[1],
          descendant: normalize_degrees(ascmc_array[0] + 180),
          imum_coeli: normalize_degrees(ascmc_array[1] + 180),
          vertex: ascmc_array[3]
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
