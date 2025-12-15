#!/usr/bin/env ruby

require_relative '../lib/ruby_chart_engine'

# Example 1: Basic Natal Chart
puts "=" * 80
puts "Example 1: Basic Natal Chart"
puts "=" * 80

natal_chart = RubyChartEngine::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York',
  house_system: :placidus
)

puts "\nSun Position:"
sun = natal_chart.planets[:sun]
puts "  Longitude: #{sun[:longitude].round(2)}°"
puts "  Sign: #{sun[:sign][:name]}"
puts "  House: #{sun[:house]}"
puts "  Movement: #{sun[:movement]}"

puts "\nMoon Position:"
moon = natal_chart.planets[:moon]
puts "  Longitude: #{moon[:longitude].round(2)}°"
puts "  Sign: #{moon[:sign][:name]}"
puts "  House: #{moon[:house]}"

puts "\nMoon Phase: #{natal_chart.moon_phase}"
puts "Chart Shape: #{natal_chart.chart_shape}"

puts "\nAspects (first 3):"
natal_chart.aspects.take(3).each do |aspect|
  puts "  #{aspect[:planet1]} #{aspect[:type]} #{aspect[:planet2]} (orb: #{aspect[:orb].round(2)}°)"
end

# Example 2: Solar Return Chart
puts "\n" + "=" * 80
puts "Example 2: Solar Return Chart for 2024"
puts "=" * 80

solar_return = RubyChartEngine::Charts::SolarReturn.new(
  natal_datetime: '1990-05-15T14:30:00',
  return_year: 2024,
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)

puts "\nSolar Return Date: #{solar_return.datetime.datetime}"
puts "Natal Sun Longitude: #{solar_return.natal_sun_longitude.round(2)}°"
puts "Solar Return Sun: #{solar_return.planets[:sun][:longitude].round(2)}°"

# Example 3: Composite Chart
puts "\n" + "=" * 80
puts "Example 3: Composite Chart"
puts "=" * 80

composite = RubyChartEngine::Charts::Composite.new(
  chart1_params: {
    datetime: '1990-05-15T14:30:00',
    latitude: 40.7128,
    longitude: -74.0060,
    timezone: 'America/New_York'
  },
  chart2_params: {
    datetime: '1992-08-20T10:00:00',
    latitude: 34.0522,
    longitude: -118.2437,
    timezone: 'America/Los_Angeles'
  }
)

puts "\nComposite Sun:"
comp_sun = composite.planets[:sun]
puts "  Longitude: #{comp_sun[:longitude].round(2)}°"
puts "  Sign: #{comp_sun[:sign][:name]}"
puts "  House: #{comp_sun[:house]}"

# Example 4: Transit Chart
puts "\n" + "=" * 80
puts "Example 4: Transit Chart"
puts "=" * 80

transit = RubyChartEngine::Charts::Transit.new(
  natal_chart_params: natal_chart,
  transit_datetime: '2024-03-15T12:00:00'
)

puts "\nTransit Aspects to Natal Chart (first 5):"
transit.transit_aspects.take(5).each do |aspect|
  puts "  Transit #{aspect[:planet1]} #{aspect[:type]} Natal #{aspect[:planet2]} (orb: #{aspect[:orb].round(2)}°)"
end

# Example 5: JSON Export
puts "\n" + "=" * 80
puts "Example 5: JSON Export"
puts "=" * 80

puts "\nNatal Chart as JSON (pretty):"
json = RubyChartEngine::Serializers::JsonSerializer.serialize_pretty(natal_chart)
puts json[0..500] + "..."

puts "\nChart with filtered output (metadata and planets only):"
filtered_json = RubyChartEngine::Serializers::JsonSerializer.serialize_with_options(
  natal_chart,
  include: [:metadata, :planets],
  pretty: true
)
puts filtered_json[0..300] + "..."

# Example 6: Different Coordinate Formats
puts "\n" + "=" * 80
puts "Example 6: Different Coordinate Formats"
puts "=" * 80

# Standard text format
chart_text = RubyChartEngine::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: '40n43',
  longitude: '74w00',
  timezone: 'America/New_York'
)

puts "\nChart with text coordinates:"
puts "  Latitude: #{chart_text.coordinates.latitude.round(4)}°"
puts "  Longitude: #{chart_text.coordinates.longitude.round(4)}°"

# Example 7: Different House Systems
puts "\n" + "=" * 80
puts "Example 7: Different House Systems"
puts "=" * 80

house_systems = [:placidus, :koch, :whole_sign, :equal]

house_systems.each do |system|
  chart = RubyChartEngine::Charts::Natal.new(
    datetime: '1990-05-15T14:30:00',
    latitude: 40.7128,
    longitude: -74.0060,
    timezone: 'America/New_York',
    house_system: system
  )

  puts "\n#{system.to_s.capitalize} House System:"
  puts "  1st House Cusp: #{chart.houses[:cusps][0].round(2)}°"
  puts "  10th House Cusp: #{chart.houses[:cusps][9].round(2)}°"
end

puts "\n" + "=" * 80
puts "Examples Complete!"
puts "=" * 80
