module Astrolith
  module Calculations
    class Dignities
      # Essential dignities table
      RULERSHIPS = {
        aries: { ruler: :mars, detriment: :venus, exaltation: :sun, fall: :saturn },
        taurus: { ruler: :venus, detriment: :mars, exaltation: :moon, fall: nil },
        gemini: { ruler: :mercury, detriment: :jupiter, exaltation: nil, fall: nil },
        cancer: { ruler: :moon, detriment: :saturn, exaltation: :jupiter, fall: :mars },
        leo: { ruler: :sun, detriment: :saturn, exaltation: nil, fall: nil },
        virgo: { ruler: :mercury, detriment: :jupiter, exaltation: :mercury, fall: :venus },
        libra: { ruler: :venus, detriment: :mars, exaltation: :saturn, fall: :sun },
        scorpio: { ruler: :mars, detriment: :venus, exaltation: nil, fall: :moon },
        sagittarius: { ruler: :jupiter, detriment: :mercury, exaltation: nil, fall: nil },
        capricorn: { ruler: :saturn, detriment: :moon, exaltation: :mars, fall: :jupiter },
        aquarius: { ruler: :saturn, detriment: :sun, exaltation: nil, fall: nil },
        pisces: { ruler: :jupiter, detriment: :mercury, exaltation: :venus, fall: :mercury }
      }.freeze

      # Modern rulerships (for outer planets)
      MODERN_RULERSHIPS = {
        scorpio: :pluto,
        aquarius: :uranus,
        pisces: :neptune
      }.freeze

      # Calculate dignities for a planet in a sign
      def self.calculate(planet_name, sign_index)
        sign_name = SIGNS[sign_index][:name].downcase.to_sym
        dignities_for_sign = RULERSHIPS[sign_name]

        return default_dignities unless dignities_for_sign

        {
          domicile: dignities_for_sign[:ruler] == planet_name,
          detriment: dignities_for_sign[:detriment] == planet_name,
          exaltation: dignities_for_sign[:exaltation] == planet_name,
          fall: dignities_for_sign[:fall] == planet_name,
          peregrine: !has_any_dignity?(planet_name, dignities_for_sign)
        }
      end

      # Calculate dignity score
      def self.score(dignities)
        score = 0
        score += 5 if dignities[:domicile]
        score += 4 if dignities[:exaltation]
        score -= 5 if dignities[:detriment]
        score -= 4 if dignities[:fall]
        score
      end

      private

      def self.has_any_dignity?(planet_name, dignities_for_sign)
        dignities_for_sign[:ruler] == planet_name ||
          dignities_for_sign[:exaltation] == planet_name
      end

      def self.default_dignities
        {
          domicile: false,
          detriment: false,
          exaltation: false,
          fall: false,
          peregrine: true
        }
      end
    end
  end
end
