require 'spec_helper'

RSpec.describe Astrolith::Serializers::JsonSerializer do
  let(:chart) do
    Astrolith::Charts::Natal.new(
      datetime: '1990-05-15T14:30:00',
      latitude: 40.7128,
      longitude: -74.0060,
      timezone: 'America/New_York'
    )
  end

  describe '.serialize' do
    it 'serializes chart to JSON' do
      json = described_class.serialize(chart)

      expect(json).to be_a(String)
      expect { JSON.parse(json) }.not_to raise_error
    end
  end

  describe '.serialize_pretty' do
    it 'serializes chart to pretty JSON' do
      json = described_class.serialize_pretty(chart)

      expect(json).to be_a(String)
      expect(json).to include("\n")
      expect { JSON.parse(json) }.not_to raise_error
    end
  end

  describe '.serialize_collection' do
    it 'serializes multiple charts' do
      chart2 = Astrolith::Charts::Natal.new(
        datetime: '1995-08-20T10:00:00',
        latitude: 34.0522,
        longitude: -118.2437,
        timezone: 'America/Los_Angeles'
      )

      json = described_class.serialize_collection([chart, chart2])

      expect(json).to be_a(String)
      parsed = JSON.parse(json)
      expect(parsed).to be_an(Array)
      expect(parsed.length).to eq(2)
    end
  end

  describe '.serialize_with_options' do
    it 'includes only specified fields' do
      json = described_class.serialize_with_options(chart, include: [:metadata, :planets])

      parsed = JSON.parse(json)
      expect(parsed.keys).to match_array(['metadata', 'planets'])
    end

    it 'excludes specified fields' do
      json = described_class.serialize_with_options(chart, exclude: [:aspects, :houses])

      parsed = JSON.parse(json)
      expect(parsed.keys).not_to include('aspects', 'houses')
    end

    it 'formats as pretty JSON when specified' do
      json = described_class.serialize_with_options(chart, pretty: true)

      expect(json).to include("\n")
    end
  end

  describe '.deserialize' do
    it 'parses JSON string to hash' do
      json = described_class.serialize(chart)
      hash = described_class.deserialize(json)

      expect(hash).to be_a(Hash)
      expect(hash).to have_key(:metadata)
      expect(hash).to have_key(:planets)
    end
  end
end
