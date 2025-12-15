require 'swe4r'
require 'ephemeris'
require 'daru'
require 'json'

require_relative 'ruby_chart_engine/version'
require_relative 'ruby_chart_engine/input/coordinates'
require_relative 'ruby_chart_engine/input/datetime'
require_relative 'ruby_chart_engine/input/timezone'

require_relative 'ruby_chart_engine/calculations/positions'
require_relative 'ruby_chart_engine/calculations/houses'
require_relative 'ruby_chart_engine/calculations/aspects'
require_relative 'ruby_chart_engine/calculations/dignities'

require_relative 'ruby_chart_engine/serializers/json_serializer'

require_relative 'ruby_chart_engine/charts/base_chart'
require_relative 'ruby_chart_engine/charts/natal'
require_relative 'ruby_chart_engine/charts/solar_return'
require_relative 'ruby_chart_engine/charts/progressed'
require_relative 'ruby_chart_engine/charts/composite'
require_relative 'ruby_chart_engine/charts/transit'

module RubyChartEngine
  class Error < StandardError; end

  # Celestial object constants
  PLANETS = {
    sun: Swe4r::SE_SUN,
    moon: Swe4r::SE_MOON,
    mercury: Swe4r::SE_MERCURY,
    venus: Swe4r::SE_VENUS,
    mars: Swe4r::SE_MARS,
    jupiter: Swe4r::SE_JUPITER,
    saturn: Swe4r::SE_SATURN,
    uranus: Swe4r::SE_URANUS,
    neptune: Swe4r::SE_NEPTUNE,
    pluto: Swe4r::SE_PLUTO
  }.freeze

  POINTS = {
    north_node: Swe4r::SE_TRUE_NODE,
    south_node: Swe4r::SE_TRUE_NODE, # Will be calculated as opposite
    chiron: Swe4r::SE_CHIRON
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
