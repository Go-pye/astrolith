module Astrolith
  module Calculations
    class Aspects
      # Standard aspect definitions with orbs
      ASPECT_TYPES = {
        conjunction: { angle: 0, orb: 8 },
        opposition: { angle: 180, orb: 8 },
        trine: { angle: 120, orb: 8 },
        square: { angle: 90, orb: 8 },
        sextile: { angle: 60, orb: 6 },
        quincunx: { angle: 150, orb: 3 },
        semi_sextile: { angle: 30, orb: 3 },
        semi_square: { angle: 45, orb: 3 },
        sesquiquadrate: { angle: 135, orb: 3 }
      }.freeze

      # Calculate all aspects between two sets of planets
      def self.calculate(planets1, planets2 = nil)
        planets2 ||= planets1
        aspects = []

        planets1.each do |name1, data1|
          planets2.each do |name2, data2|
            # Skip if comparing planet to itself
            next if planets2.equal?(planets1) && name1 == name2

            # Skip if we've already calculated this pair (for same chart)
            next if planets2.equal?(planets1) && planets1.keys.index(name1) >= planets1.keys.index(name2)

            aspect = find_aspect(
              data1[:longitude],
              data2[:longitude],
              name1,
              name2
            )

            aspects << aspect if aspect
          end
        end

        aspects
      end

      # Find aspect between two longitudes
      def self.find_aspect(lon1, lon2, name1, name2)
        angle = calculate_angle(lon1, lon2)

        ASPECT_TYPES.each do |type, config|
          diff = (angle - config[:angle]).abs

          if diff <= config[:orb]
            return {
              type: type,
              planet1: name1,
              planet2: name2,
              angle: config[:angle],
              orb: diff,
              applying: false # TODO: Calculate if aspect is applying or separating
            }
          end
        end

        nil
      end

      # Calculate the angle between two longitudes
      def self.calculate_angle(lon1, lon2)
        diff = (lon2 - lon1).abs
        diff = 360 - diff if diff > 180
        diff
      end

      # Determine if aspect is applying or separating based on speeds
      def self.applying?(planet1_data, planet2_data, aspect_angle)
        # Get speeds
        speed1 = planet1_data[:speed_longitude]
        speed2 = planet2_data[:speed_longitude]

        # If speeds are moving toward exact aspect, it's applying
        # This is a simplified calculation
        relative_speed = speed2 - speed1

        # If faster planet is behind slower planet, aspect is applying
        relative_speed > 0
      end
    end
  end
end
