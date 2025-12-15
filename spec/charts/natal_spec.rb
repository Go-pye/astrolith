require 'spec_helper'

RSpec.describe RubyChartEngine::Charts::Natal do
  let(:chart_params) do
    {
      datetime: '1990-05-15T14:30:00',
      latitude: 40.7128,
      longitude: -74.0060,
      timezone: 'America/New_York'
    }
  end

  describe '#initialize' do
    it 'creates a natal chart' do
      chart = described_class.new(**chart_params)

      expect(chart).to be_a(described_class)
      expect(chart.planets).to be_a(Hash)
      expect(chart.houses).to be_a(Hash)
    end

    it 'calculates planetary positions' do
      chart = described_class.new(**chart_params)

      expect(chart.planets).to have_key(:sun)
      expect(chart.planets).to have_key(:moon)
      expect(chart.planets).to have_key(:mercury)

      # Check that Sun has expected data structure
      sun = chart.planets[:sun]
      expect(sun).to have_key(:longitude)
      expect(sun).to have_key(:sign)
      expect(sun).to have_key(:house)
      expect(sun).to have_key(:movement)
      expect(sun).to have_key(:dignities)
    end

    it 'calculates houses' do
      chart = described_class.new(**chart_params)

      expect(chart.houses[:cusps]).to be_an(Array)
      expect(chart.houses[:cusps].length).to eq(12)
    end

    it 'calculates aspects' do
      chart = described_class.new(**chart_params)

      expect(chart.aspects).to be_an(Array)
    end
  end

  describe '#moon_phase' do
    it 'calculates moon phase' do
      chart = described_class.new(**chart_params)

      phase = chart.moon_phase
      expect(phase).to be_a(String)
      expect(['New Moon', 'Waxing Crescent', 'First Quarter', 'Waxing Gibbous',
              'Full Moon', 'Waning Gibbous', 'Last Quarter', 'Waning Crescent']).to include(phase)
    end
  end

  describe '#chart_shape' do
    it 'calculates chart shape' do
      chart = described_class.new(**chart_params)

      shape = chart.chart_shape
      expect(shape).to be_a(String)
      expect(['bundle', 'bowl', 'bucket', 'splay', 'splash']).to include(shape)
    end
  end

  describe '#to_hash' do
    it 'returns a hash representation' do
      chart = described_class.new(**chart_params)

      hash = chart.to_hash
      expect(hash).to be_a(Hash)
      expect(hash).to have_key(:metadata)
      expect(hash).to have_key(:planets)
      expect(hash).to have_key(:houses)
      expect(hash).to have_key(:angles)
      expect(hash).to have_key(:aspects)
      expect(hash).to have_key(:moon_phase)
      expect(hash).to have_key(:chart_shape)
    end
  end

  describe '#to_json' do
    it 'returns a JSON string' do
      chart = described_class.new(**chart_params)

      json = chart.to_json
      expect(json).to be_a(String)
      expect { JSON.parse(json) }.not_to raise_error
    end
  end
end
