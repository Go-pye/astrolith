module Astrolith
  module Calculations
    class Positions
      attr_reader :julian_day, :latitude, :longitude

      def initialize(julian_day:, latitude:, longitude:)
        @julian_day = julian_day
        @latitude = latitude
        @longitude = longitude
      end

      # Calculate position for a single celestial object
      def calculate_planet(planet_id)
        # Calculation flags: 4 = SEFLG_MOSEPH (use built-in Moshier ephemeris), 256 = SEFLG_SPEED
        # Using Moshier ephemeris (analytical) to avoid needing external ephemeris files
        # Provides precision of ~0.1 arc seconds for planets, ~3" for Moon
        flags = 4 | 256  # SEFLG_MOSEPH | SEFLG_SPEED

        result = Swe4r.swe_calc_ut(julian_day, planet_id, flags)

        # swe_calc_ut returns an array: [longitude, latitude, distance, speed_long, speed_lat, speed_dist]
        # Extract values based on whether it's an array or hash
        if result.is_a?(Array)
          {
            longitude: result[0],
            latitude: result[1],
            distance: result[2],
            speed_longitude: result[3],
            speed_latitude: result[4],
            speed_distance: result[5]
          }
        elsif result.is_a?(Hash)
          {
            longitude: result[:longitude] || result['longitude'],
            latitude: result[:latitude] || result['latitude'],
            distance: result[:distance] || result['distance'],
            speed_longitude: result[:speed_longitude] || result['speed_longitude'],
            speed_latitude: result[:speed_latitude] || result['speed_latitude'],
            speed_distance: result[:speed_distance] || result['speed_distance']
          }
        else
          raise Error, "Unexpected swe_calc_ut return type: #{result.class}"
        end
      rescue => e
        raise Error, "Failed to calculate position for planet #{planet_id}: #{e.message}"
      end

      # Calculate all planets
      def calculate_all_planets
        positions = {}

        PLANETS.each do |name, id|
          positions[name] = calculate_planet(id)
        end

        # Calculate points
        POINTS.each do |name, id|
          if name == :south_node
            # South Node is opposite of North Node
            north_node = calculate_planet(POINTS[:north_node])
            positions[name] = north_node.dup
            positions[name][:longitude] = normalize_degrees(north_node[:longitude] + 180)
          elsif name == :chiron
            # Chiron is not available in Moshier ephemeris, skip it
            # Would require external ephemeris files (seas_*.se1)
            next
          else
            positions[name] = calculate_planet(id)
          end
        end

        positions
      end

      # Get sign from longitude
      def longitude_to_sign(longitude)
        sign_index = (longitude / 30).floor
        sign_longitude = longitude % 30

        {
          index: sign_index,
          sign: SIGNS[sign_index],
          longitude: sign_longitude,
          decan: ((sign_longitude / 10).floor + 1)
        }
      end

      # Determine if planet is retrograde
      def retrograde?(speed)
        speed < 0
      end

      # Get movement status
      def movement_status(speed)
        if speed.abs < 0.0001
          'stationary'
        elsif speed < 0
          'retrograde'
        else
          'direct'
        end
      end

      private

      def normalize_degrees(degrees)
        degrees = degrees % 360
        degrees += 360 if degrees < 0
        degrees
      end
    end
  end
end
