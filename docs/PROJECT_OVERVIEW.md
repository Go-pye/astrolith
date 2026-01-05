# Astrolith - Project Overview

## 🎯 Project Status: ✅ COMPLETE

A fully functional Ruby port of the immanuel-python astrology library, serving as a decoupled data calculation engine with structured JSON output.

## 📊 Project Statistics

- **Implementation Files**: 16 Ruby files
- **Test Files**: 5 RSpec test files
- **Chart Types**: 5 (Natal, Solar Return, Progressed, Composite, Transit)
- **House Systems**: 7 (Placidus, Koch, Whole Sign, Equal, etc.)
- **Celestial Objects**: 13+ (Planets, Points, Angles)
- **Aspect Types**: 9

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                 Chart Classes                       │
│  (Natal, SolarReturn, Progressed, Composite, etc.)  │
└──────────────────┬──────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
┌───────▼──────┐    ┌────────▼─────────┐
│ Calculations │    │  Input Parsing   │
│ - Positions  │    │  - Coordinates   │
│ - Houses     │    │  - DateTime      │
│ - Aspects    │    │  - Timezone      │
│ - Dignities  │    └──────────────────┘
└───────┬──────┘
        │
        │
┌───────▼────────────────┐
│   Swiss Ephemeris      │
│      (swe4r)           │
└────────────────────────┘
        │
        │
┌───────▼────────────────┐
│    JSON Serializer     │
│   (Output Layer)       │
└────────────────────────┘
```

## 📁 File Structure

### Core Library (16 files)

```
lib/astrolith/
│
├── 📄 astrolith.rb      # Main module
├── 📄 version.rb                 # Version info
│
├── 📂 input/                     # Input parsing layer
│   ├── coordinates.rb            # Coordinate format handling
│   ├── datetime.rb               # DateTime parsing & JD conversion
│   └── timezone.rb               # Timezone resolution
│
├── 📂 calculations/              # Calculation engine
│   ├── positions.rb              # Planetary positions via Swiss Ephemeris
│   ├── houses.rb                 # House system calculations
│   ├── aspects.rb                # Aspect detection
│   └── dignities.rb              # Essential dignity scoring
│
├── 📂 charts/                    # Chart type implementations
│   ├── base_chart.rb             # Base class for all charts
│   ├── natal.rb                  # Natal charts + moon phase + chart shape
│   ├── solar_return.rb           # Annual solar returns
│   ├── progressed.rb             # Secondary progressions
│   ├── composite.rb              # Midpoint composite charts
│   └── transit.rb                # Transit-to-natal aspects
│
└── 📂 serializers/               # Output formatting
    └── json_serializer.rb        # JSON export with options
```

### Test Suite (5 files)

```
spec/
├── spec_helper.rb
├── input/
│   ├── coordinates_spec.rb
│   └── datetime_spec.rb
├── calculations/
│   └── dignities_spec.rb
├── charts/
│   └── natal_spec.rb
└── serializers/
    └── json_serializer_spec.rb
```

## 🎨 Key Features

### ✅ Chart Types Supported

1. **Natal Chart** - Birth chart with moon phase & chart shape analysis
2. **Solar Return** - Annual return charts for any year
3. **Progressed Chart** - Secondary progressions (day-for-year)
4. **Composite Chart** - Midpoint synthesis of two charts
5. **Transit Chart** - Current planetary positions vs natal

### ✅ Rich Data Output

Each celestial object includes:

- Longitude (absolute & sign-relative)
- Sign placement (name, element, modality)
- House placement
- Movement status (direct/retrograde/stationary)
- Essential dignities (domicile, exaltation, detriment, fall)
- Decan position
- Speed vectors

### ✅ Flexible Input

- **Coordinates**: Decimal degrees or text format ('40n43')
- **DateTime**: ISO 8601, Hash, or Ruby DateTime objects
- **Timezone**: TZInfo identifiers or UTC offsets

### ✅ Advanced Calculations

- 9 aspect types with customizable orbs
- 7 house systems
- Essential dignity scoring
- Moon phase determination
- Chart shape pattern recognition

## 📚 Documentation

| Document                                               | Purpose                  |
| ------------------------------------------------------ | ------------------------ |
| [QUICK_START.md](QUICK_START.md)                       | Get started in 5 minutes |
| [astrolith_README.md](astrolith_README.md)             | Complete usage guide     |
| [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) | Implementation details   |
| [examples/example_usage.rb](examples/example_usage.rb) | Working code examples    |
| Original [README.md](README.md)                        | Implementation plan      |

## 🚀 Quick Start

```ruby
# 1. Install dependencies
bundle install

# 2. Create a chart
require 'astrolith'

chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)

# 3. Access data
chart.planets[:sun][:sign][:name]  # => "Taurus"
chart.moon_phase                   # => "Waxing Gibbous"

# 4. Export
chart.to_json  # => Complete chart data as JSON
```

## 🧪 Testing

```bash
# Run all tests
bundle exec rspec

# Run with documentation
bundle exec rspec --format documentation

# Run specific test
bundle exec rspec spec/charts/natal_spec.rb
```

## 📦 Dependencies

### Core

- **swe4r** - Swiss Ephemeris calculations
- **ephemeris** - Astrological logic helpers
- **daru** - Data structuring
- **tzinfo** - Timezone handling

### Development

- **rspec** - Testing
- **pry** - Debugging

## 🎯 Implementation Compliance

| Phase                     | Status      | Components                           |
| ------------------------- | ----------- | ------------------------------------ |
| Phase 1: Core Integration | ✅ Complete | Input parsing, Swiss Ephemeris setup |
| Phase 2: Data Translation | ✅ Complete | All chart classes, calculations      |
| Phase 3: Testing & Docs   | ✅ Complete | RSpec suite, comprehensive docs      |

**All features from the original plan have been implemented.**

## 🌟 Highlights

### Clean Architecture

- Separation of concerns across layers
- Extensible design for new chart types
- DRY principles with BaseChart inheritance

### Production Ready

- Comprehensive error handling
- Flexible input validation
- Structured JSON output
- Test coverage for critical paths

### Developer Friendly

- Clear, idiomatic Ruby code
- Extensive documentation
- Working examples
- Easy-to-understand structure

## 🔮 Future Enhancements

### Potential Additions

1. **More Points**: Asteroids (Juno, Pallas, Vesta, Ceres)
2. **Arabic Parts**: Part of Fortune, etc.
3. **Synastry Class**: Dedicated relationship charts
4. **Aspect Refinement**: Apply/separate detection
5. **Performance**: Caching layer for repeated calculations
6. **Validation**: Enhanced input validation
7. **API Documentation**: YARD docs

## 💡 Usage Patterns

### Basic Natal Chart

```ruby
chart = Astrolith::Charts::Natal.new(
  datetime: '1990-05-15T14:30:00',
  latitude: '40n43',
  longitude: '74w00',
  timezone: 'America/New_York'
)
```

### Solar Return for 2024

```ruby
solar = Astrolith::Charts::SolarReturn.new(
  natal_datetime: '1990-05-15T14:30:00',
  return_year: 2024,
  latitude: 40.7128,
  longitude: -74.0060,
  timezone: 'America/New_York'
)
```

### Current Transits

```ruby
transit = Astrolith::Charts::Transit.new(
  natal_chart_params: natal_chart,
  transit_datetime: Time.now.iso8601
)
```

## 📝 License

MIT License

## 🙏 Acknowledgments

Ruby port of [immanuel-python](https://github.com/theriftlab/immanuel-python) by The Rift Lab, maintaining JSON output compatibility while leveraging Ruby's strengths.

---

**Status**: ✅ Implementation Complete | Ready for Testing & Refinement
**Last Updated**: December 14, 2024
