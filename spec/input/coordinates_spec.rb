require 'spec_helper'

RSpec.describe RubyChartEngine::Input::Coordinates do
  describe '#initialize' do
    context 'with decimal degrees' do
      it 'parses numeric coordinates' do
        coords = described_class.new(lat: 32.7157, lon: -117.1611)
        expect(coords.latitude).to be_within(0.001).of(32.7157)
        expect(coords.longitude).to be_within(0.001).of(-117.1611)
      end

      it 'parses string decimal coordinates' do
        coords = described_class.new(lat: '32.7157', lon: '-117.1611')
        expect(coords.latitude).to be_within(0.001).of(32.7157)
        expect(coords.longitude).to be_within(0.001).of(-117.1611)
      end
    end

    context 'with standard text format' do
      it 'parses latitude with north direction' do
        coords = described_class.new(lat: '32n43', lon: '117w10')
        expect(coords.latitude).to be_within(0.1).of(32.71)
      end

      it 'parses latitude with south direction' do
        coords = described_class.new(lat: '34s00', lon: '151e00')
        expect(coords.latitude).to be_within(0.1).of(-34.0)
      end

      it 'parses longitude with west direction' do
        coords = described_class.new(lat: '40n45', lon: '73w59')
        expect(coords.longitude).to be_within(0.1).of(-73.98)
      end

      it 'parses longitude with east direction' do
        coords = described_class.new(lat: '51n30', lon: '0e07')
        expect(coords.longitude).to be_within(0.1).of(0.11)
      end
    end

    context 'with invalid format' do
      it 'raises an error' do
        expect {
          described_class.new(lat: 'invalid', lon: '117w10')
        }.to raise_error(RubyChartEngine::Error)
      end
    end
  end
end
