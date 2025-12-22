module Astrolith
  module Charts
    class BaseChart
      attr_reader :datetime, :coordinates, :timezone, :house_system,
                  :julian_day, :houses, :angles, :planets, :aspects

      def initialize(datetime:, latitude:, longitude:, timezone: 'UTC', house_system: :placidus)
        # Parse inputs
        @datetime = Input::DateTime.new(datetime)
        @coordinates = Input::Coordinates.new(lat: latitude, lon: longitude)
        @timezone = Input::Timezone.new(timezone, @datetime.datetime)
        @house_system = house_system

        # Calculate Julian Day
        @julian_day = @datetime.to_julian_day(@timezone.offset_hours)

        # Initialize calculators
        @position_calc = Calculations::Positions.new(
          julian_day: @julian_day,
          latitude: @coordinates.latitude,
          longitude: @coordinates.longitude
        )

        @house_calc = Calculations::Houses.new(
          julian_day: @julian_day,
          latitude: @coordinates.latitude,
          longitude: @coordinates.longitude,
          house_system: @house_system
        )

        # Perform calculations
        calculate!
      end

      def to_json(*args)
        to_hash.to_json(*args)
      end

      def to_hash
        {
          metadata: metadata,
          planets: format_planets,
          houses: format_houses,
          angles: format_angles,
          aspects: @aspects
        }
      end

      private

      def calculate!
        # Calculate houses and angles
        house_data = @house_calc.calculate
        @house_cusps = house_data[:cusps]
        @angles = house_data[:angles]
        @houses = house_data  # Store full house data including cusps and angles

        # Calculate planetary positions
        @planets = calculate_planets

        # Calculate aspects
        @aspects = Calculations::Aspects.calculate(@planets)
      end

      def calculate_planets
        raw_positions = @position_calc.calculate_all_planets
        formatted_planets = {}

        raw_positions.each do |name, data|
          sign_data = @position_calc.longitude_to_sign(data[:longitude])
          house_number = @house_calc.house_for_longitude(data[:longitude], @house_cusps)

          formatted_planets[name] = {
            longitude: data[:longitude],
            latitude: data[:latitude],
            distance: data[:distance],
            speed_longitude: data[:speed_longitude],
            sign_longitude: sign_data[:longitude],
            sign: sign_data[:sign],
            house: house_number,
            decan: sign_data[:decan],
            movement: @position_calc.movement_status(data[:speed_longitude]),
            dignities: Calculations::Dignities.calculate(name, sign_data[:index])
          }
        end

        # Add angles as celestial points
        @angles.each do |name, longitude|
          next if name == :vertex # Skip vertex for now

          sign_data = @position_calc.longitude_to_sign(longitude)

          formatted_planets[name] = {
            longitude: longitude,
            sign_longitude: sign_data[:longitude],
            sign: sign_data[:sign],
            decan: sign_data[:decan]
          }
        end

        formatted_planets
      end

      def format_planets
        @planets.select { |name, _| !ANGLES.keys.include?(name) }
      end

      def format_angles
        @planets.select { |name, _| ANGLES.keys.include?(name) }
      end

      def format_houses
        @house_cusps.each_with_index.map do |cusp, index|
          sign_data = @position_calc.longitude_to_sign(cusp)
          {
            number: index + 1,
            cusp: cusp,
            sign: sign_data[:sign]
          }
        end
      end

      def metadata
        {
          datetime: @datetime.datetime.iso8601,
          julian_day: @julian_day,
          latitude: @coordinates.latitude,
          longitude: @coordinates.longitude,
          timezone: @timezone.timezone.to_s,
          house_system: @house_system.to_s
        }
      end
    end
  end
end
