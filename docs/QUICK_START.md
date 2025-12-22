# Astrolith - Quick Start Guide

## Installation

```bash
# Install dependencies
bundle install
```

## Basic Usage

### 1. Create Your First Natal Chart

```ruby
require 'astrolith'

chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)

# Access Sun position
puts chart.planets[:sun][:sign][:name]  # => "Taurus"
puts chart.planets[:sun][:house]        # => 10
```

### 2. Get Chart as JSON

```ruby
# Compact JSON
json = chart.to_json

# Pretty JSON
require 'astrolith'
pretty_json = Astrolith::Serializers::JsonSerializer.serialize_pretty(chart)
puts pretty_json
```

### 3. Calculate Solar Return

```ruby
solar_return = Astrolith::Charts::SolarReturn.new(
  natal_datetime: '1990-05-15T14:30:00',
  return_year: 2024,
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)

puts "Solar Return: #{solar_return.datetime.datetime}"
```

### 4. Check Current Transits

```ruby
# First, create natal chart
natal = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)

# Then calculate transits
transit = Astrolith::Charts::Transit.new(
  natal_chart_params: natal,
  transit_datetime: Time.now.iso8601
)

# View transit aspects
transit.transit_aspects.each do |aspect|
  puts "#{aspect[:planet1]} #{aspect[:type]} #{aspect[:planet2]}"
end
```

## Running Examples

```bash
# Run the comprehensive example file
ruby examples/example_usage.rb
```

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/charts/natal_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

## Common Patterns

### Different Coordinate Formats

```ruby
# Decimal degrees
chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'UTC'
)

# Text format (degrees and minutes)
chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: '40n43',
  longitude: '74w00',
  timezone: 'UTC'
)
```

### Different House Systems

```ruby
# Placidus (default)
chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'UTC',
  house_system: :placidus
)

# Whole Sign
chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'UTC',
  house_system: :whole_sign
)

# Available: :placidus, :koch, :porphyrius, :regiomontanus, :campanus, :equal, :whole_sign
```

### Accessing Chart Data

```ruby
chart = Astrolith::Charts::Natal.new(...)

# Planets
chart.planets[:sun][:longitude]      # Raw longitude (0-360)
chart.planets[:sun][:sign_longitude]  # Sign-relative longitude (0-30)
chart.planets[:sun][:sign][:name]     # "Taurus"
chart.planets[:sun][:house]           # 10
chart.planets[:sun][:movement]        # "direct"
chart.planets[:sun][:dignities]       # { domicile: false, ... }

# Houses
chart.houses[:cusps][0]               # 1st house cusp
chart.houses[:cusps][9]               # 10th house cusp

# Angles
chart.angles[:ascendant][:longitude]  # Ascendant degree
chart.angles[:midheaven][:sign][:name] # MC sign

# Aspects
chart.aspects.each do |aspect|
  puts "#{aspect[:planet1]} #{aspect[:type]} #{aspect[:planet2]} (#{aspect[:orb]}°)"
end

# Special features (Natal only)
chart.moon_phase                      # "Waxing Gibbous"
chart.chart_shape                     # "bowl"
```

## Troubleshooting

### Missing Dependencies

If you get gem errors, make sure all dependencies are installed:

```bash
bundle install
```

### Swiss Ephemeris Data

Some calculations may require Swiss Ephemeris data files. The library will use built-in data, but for extended date ranges, download data files from:
https://www.astro.com/swisseph/

### Timezone Issues

Make sure you're using valid TZInfo timezone identifiers:

```ruby
# Good
timezone: 'America/New_York'
timezone: 'Europe/London'
timezone: 'UTC'

# Also acceptable
timezone: -5    # UTC offset in hours
timezone: '+05:30'
```

## Next Steps

1. Read the full documentation in [astrolith_README.md](astrolith_README.md)
2. Explore examples in [examples/example_usage.rb](examples/example_usage.rb)
3. Check the implementation details in [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
4. Review the original plan in [README.md](README.md)

## Quick Reference

### Chart Types
```ruby
Astrolith::Charts::Natal.new(datetime:, latitude:, longitude:, timezone:)
Astrolith::Charts::SolarReturn.new(natal_datetime:, return_year:, latitude:, longitude:, timezone:)
Astrolith::Charts::Progressed.new(natal_datetime:, progression_date:, latitude:, longitude:, timezone:)
Astrolith::Charts::Composite.new(chart1_params:, chart2_params:)
Astrolith::Charts::Transit.new(natal_chart_params:, transit_datetime:)
```

### Available Planets & Points
- Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto
- North Node, South Node, Chiron
- Ascendant, Midheaven, Descendant, Imum Coeli

### Aspect Types
- Conjunction (0°), Opposition (180°), Trine (120°), Square (90°), Sextile (60°)
- Quincunx (150°), Semi-Sextile (30°), Semi-Square (45°), Sesquiquadrate (135°)

### Dignities
- Domicile (ruler), Detriment, Exaltation, Fall, Peregrine

## Support

For issues, questions, or contributions, please refer to the project repository.
