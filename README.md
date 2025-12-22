# Astrolith

A Ruby port of the [immanuel-python](https://github.com/theriftlab/immanuel-python) astrology library, functioning as a decoupled data calculation engine with structured JSON output.

[![Tests](https://img.shields.io/badge/tests-passing-brightgreen)]()
[![Ruby](https://img.shields.io/badge/ruby-3.1%2B-red)]()

## Features

- **Multiple Chart Types**: Natal, Solar Return, Progressed, Composite, Transit
- **Comprehensive Data**: Planets, houses, aspects, dignities, decans, moon phase, chart shape
- **Swiss Ephemeris**: High-precision astronomical calculations using built-in Moshier ephemeris
- **No External Files Required**: Uses analytical ephemeris (precision: ~0.1 arc seconds for planets, ~3" for Moon)
- **JSON Output**: Structured data output for easy integration
- **Flexible Input**: Multiple formats for coordinates, datetime, and timezone
- **7 House Systems**: Placidus, Koch, Whole Sign, Equal, Porphyrius, Regiomontanus, Campanus

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'astrolith'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install astrolith
```

## Quick Start

```ruby
require 'astrolith'

# Create a natal chart
chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York',
  house_system: :placidus
)

# Access chart data
puts chart.planets[:sun][:sign][:name]  # => "Taurus"
puts chart.planets[:sun][:house]        # => 10
puts chart.moon_phase                   # => "Waxing Gibbous"
puts chart.chart_shape                  # => "bowl"

# Export to JSON
json = chart.to_json
puts json
```

## Usage Examples

### Natal Chart

```ruby
chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)

# Access planetary data
sun = chart.planets[:sun]
# => {
#   longitude: 54.123,
#   sign_longitude: 24.123,
#   sign: { name: "Taurus", element: "Earth", modality: "Fixed" },
#   house: 10,
#   decan: 3,
#   movement: "direct",
#   dignities: { domicile: false, exaltation: false, ... }
# }

# Check aspects
chart.aspects.each do |aspect|
  puts "#{aspect[:planet1]} #{aspect[:type]} #{aspect[:planet2]} (orb: #{aspect[:orb]}°)"
end
```

### Solar Return

```ruby
solar_return = Astrolith::Charts::SolarReturn.new(
  natal_datetime: '1990-05-15T14:30:00',
  return_year: 2024,
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)
```

### Progressed Chart

```ruby
progressed = Astrolith::Charts::Progressed.new(
  natal_datetime: '1990-05-15T14:30:00',
  progression_date: '2024-03-15',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)
```

### Composite Chart

```ruby
composite = Astrolith::Charts::Composite.new(
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
```

### Transit Chart

```ruby
natal = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)

transit = Astrolith::Charts::Transit.new(
  natal_chart_params: natal,
  transit_datetime: Time.now.iso8601
)

# View transit aspects
transit.transit_aspects.each do |aspect|
  puts "#{aspect[:planet1]} #{aspect[:type]} #{aspect[:planet2]}"
end
```

## Input Formats

### Coordinates

```ruby
# Decimal degrees
latitude: 40.7128, longitude: -74.0060

# Text format (degrees and minutes)
latitude: '40n43', longitude: '74w00'

# Mixed formats work too
latitude: 40.7128, longitude: '74w00'
```

### DateTime

```ruby
# ISO 8601 string
datetime: '1990-05-15T14:30:00'

# Hash
datetime: { year: 1990, month: 5, day: 15, hour: 14, minute: 30 }

# Ruby DateTime object
datetime: DateTime.new(1990, 5, 15, 14, 30, 0)
```

### House Systems

```ruby
# Available systems:
house_system: :placidus       # Default
house_system: :koch
house_system: :whole_sign
house_system: :equal
house_system: :porphyrius
house_system: :regiomontanus
house_system: :campanus
```

## Output Structure

```json
{
  "metadata": {
    "datetime": "1990-05-15T14:30:00+00:00",
    "julian_day": 2448025.1041666665,
    "latitude": 40.7128,
    "longitude": -74.006,
    "timezone": "America/New_York",
    "house_system": "placidus"
  },
  "planets": {
    "sun": {
      "longitude": 54.123,
      "sign_longitude": 24.123,
      "sign": { "name": "Taurus", "element": "Earth", "modality": "Fixed" },
      "house": 10,
      "decan": 3,
      "movement": "direct",
      "dignities": { "domicile": false, "exaltation": false, ... }
    }
  },
  "houses": { "cusps": [...] },
  "angles": { "ascendant": {...}, "midheaven": {...}, ... },
  "aspects": [...],
  "moon_phase": "Waxing Gibbous",
  "chart_shape": "bowl"
}
```

## Celestial Objects

**Planets**: Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto

**Points**: North Node, South Node _(Note: Chiron is not available when using the built-in Moshier ephemeris)_

**Angles**: Ascendant, Midheaven, Descendant, Imum Coeli

## Aspects

Supported aspects with configurable orbs:

- Conjunction (0°)
- Opposition (180°)
- Trine (120°)
- Square (90°)
- Sextile (60°)
- Quincunx (150°)
- Semi-Sextile (30°)
- Semi-Square (45°)
- Sesquiquadrate (135°)

## Testing

Run the test suite:

```bash
bundle exec rspec

# With documentation format
bundle exec rspec --format documentation

# Run specific test file
bundle exec rspec spec/charts/natal_spec.rb
```

## Dependencies

- **swe4r**: Swiss Ephemeris C extension for astronomical calculations
- **ephemeris**: Higher-level astrological logic built on swe4r
- **daru**: Data Analysis in Ruby for data structuring
- **tzinfo**: Timezone handling

### Optional Visualization

- **apexcharts**: For analytical charts
- **prawn**: For PDF and geometric drawing (chart wheels)

## Documentation

- [Quick Start Guide](docs/QUICK_START.md) - Get started quickly with common use cases
- [Project Overview](docs/PROJECT_OVERVIEW.md) - Architecture and implementation details
- [Implementation Summary](docs/IMPLEMENTATION_SUMMARY.md) - Technical implementation notes

## Development

After checking out the repo:

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec
```

## License

MIT License

## Acknowledgments

This library is a Ruby port of [immanuel-python](https://github.com/theriftlab/immanuel-python), maintaining compatibility with its JSON output structure while leveraging Ruby's ecosystem.

## Notes

- This implementation uses the **built-in Moshier ephemeris** (analytical calculations) which provides excellent precision without requiring external ephemeris files
- Chiron is not available with the Moshier ephemeris (would require external `.se1` files)
- For production use with extended date ranges or maximum precision, consider using the full Swiss Ephemeris with external data files
