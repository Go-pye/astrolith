module RubyChartEngine
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
        result = Swe4r.swe_calc_ut(julian_day, planet_id, Swe4r::SEFLG_SWIEPH | Swe4r::SEFLG_SPEED)

        {
          longitude: result[:longitude],
          latitude: result[:latitude],
          distance: result[:distance],
          speed_longitude: result[:speed_longitude],
          speed_latitude: result[:speed_latitude],
          speed_distance: result[:speed_distance]
        }
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
