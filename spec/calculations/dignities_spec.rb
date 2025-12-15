require 'spec_helper'

RSpec.describe RubyChartEngine::Calculations::Dignities do
  describe '.calculate' do
    context 'with planet in domicile' do
      it 'returns domicile true for Sun in Leo' do
        dignities = described_class.calculate(:sun, 4) # Leo is index 4

        expect(dignities[:domicile]).to be true
        expect(dignities[:detriment]).to be false
        expect(dignities[:exaltation]).to be false
        expect(dignities[:fall]).to be false
      end

      it 'returns domicile true for Moon in Cancer' do
        dignities = described_class.calculate(:moon, 3) # Cancer is index 3

        expect(dignities[:domicile]).to be true
      end
    end

    context 'with planet in detriment' do
      it 'returns detriment true for Sun in Aquarius' do
        dignities = described_class.calculate(:sun, 10) # Aquarius is index 10

        expect(dignities[:domicile]).to be false
        expect(dignities[:detriment]).to be true
      end
    end

    context 'with planet in exaltation' do
      it 'returns exaltation true for Sun in Aries' do
        dignities = described_class.calculate(:sun, 0) # Aries is index 0

        expect(dignities[:exaltation]).to be true
      end
    end

    context 'with planet in fall' do
      it 'returns fall true for Sun in Libra' do
        dignities = described_class.calculate(:sun, 6) # Libra is index 6

        expect(dignities[:fall]).to be true
      end
    end

    context 'with planet in peregrine' do
      it 'returns peregrine true for planet with no dignities' do
        dignities = described_class.calculate(:mercury, 4) # Mercury in Leo

        expect(dignities[:peregrine]).to be true
      end
    end
  end

  describe '.score' do
    it 'returns +5 for domicile' do
      score = described_class.score(
        domicile: true,
        detriment: false,
        exaltation: false,
        fall: false,
        peregrine: false
      )

      expect(score).to eq(5)
    end

    it 'returns +4 for exaltation' do
      score = described_class.score(
        domicile: false,
        detriment: false,
        exaltation: true,
        fall: false,
        peregrine: false
      )

      expect(score).to eq(4)
    end

    it 'returns -5 for detriment' do
      score = described_class.score(
        domicile: false,
        detriment: true,
        exaltation: false,
        fall: false,
        peregrine: false
      )

      expect(score).to eq(-5)
    end

    it 'returns -4 for fall' do
      score = described_class.score(
        domicile: false,
        detriment: false,
        exaltation: false,
        fall: true,
        peregrine: false
      )

      expect(score).to eq(-4)
    end
  end
end
