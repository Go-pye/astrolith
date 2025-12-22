require 'swe4r'
require 'ephemeris'
require 'daru'
require 'json'

require_relative 'astrolith/version'
require_relative 'astrolith/input/coordinates'
require_relative 'astrolith/input/datetime'
require_relative 'astrolith/input/timezone'

require_relative 'astrolith/calculations/positions'
require_relative 'astrolith/calculations/houses'
require_relative 'astrolith/calculations/aspects'
require_relative 'astrolith/calculations/dignities'

require_relative 'astrolith/serializers/json_serializer'

require_relative 'astrolith/charts/base_chart'
require_relative 'astrolith/charts/natal'
require_relative 'astrolith/charts/solar_return'
require_relative 'astrolith/charts/progressed'
require_relative 'astrolith/charts/composite'
require_relative 'astrolith/charts/transit'

module Astrolith
  class Error < StandardError; end

  # Swiss Ephemeris object ID constants
  # These are standard SE values used across all implementations
  PLANETS = {
    sun: 0,       # SE_SUN
    moon: 1,      # SE_MOON
    mercury: 2,   # SE_MERCURY
    venus: 3,     # SE_VENUS
    mars: 4,      # SE_MARS
    jupiter: 5,   # SE_JUPITER
    saturn: 6,    # SE_SATURN
    uranus: 7,    # SE_URANUS
    neptune: 8,   # SE_NEPTUNE
    pluto: 9      # SE_PLUTO
  }.freeze

  POINTS = {
    north_node: 10,  # SE_TRUE_NODE (or use 11 for mean node)
    south_node: 10,  # Will be calculated as opposite of north node
    chiron: 15       # SE_CHIRON
  }.freeze

  ANGLES = {
    ascendant: :asc,
    midheaven: :mc,
    descendant: :dsc,
    imum_coeli: :ic
  }.freeze

  # Zodiac signs
  SIGNS = [
    { name: 'Aries', element: 'Fire', modality: 'Cardinal' },
    { name: 'Taurus', element: 'Earth', modality: 'Fixed' },
    { name: 'Gemini', element: 'Air', modality: 'Mutable' },
    { name: 'Cancer', element: 'Water', modality: 'Cardinal' },
    { name: 'Leo', element: 'Fire', modality: 'Fixed' },
    { name: 'Virgo', element: 'Earth', modality: 'Mutable' },
    { name: 'Libra', element: 'Air', modality: 'Cardinal' },
    { name: 'Scorpio', element: 'Water', modality: 'Fixed' },
    { name: 'Sagittarius', element: 'Fire', modality: 'Mutable' },
    { name: 'Capricorn', element: 'Earth', modality: 'Cardinal' },
    { name: 'Aquarius', element: 'Air', modality: 'Fixed' },
    { name: 'Pisces', element: 'Water', modality: 'Mutable' }
  ].freeze

  # House systems
  HOUSE_SYSTEMS = {
    placidus: 'P',
    koch: 'K',
    porphyrius: 'O',
    regiomontanus: 'R',
    campanus: 'C',
    equal: 'E',
    whole_sign: 'W'
  }.freeze
end
