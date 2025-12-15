require 'spec_helper'

RSpec.describe RubyChartEngine::Input::DateTime do
  describe '#initialize' do
    context 'with DateTime object' do
      it 'parses DateTime object' do
        dt = DateTime.new(2024, 3, 15, 14, 30, 0)
        input_dt = described_class.new(dt)

        expect(input_dt.year).to eq(2024)
        expect(input_dt.month).to eq(3)
        expect(input_dt.day).to eq(15)
        expect(input_dt.hour).to eq(14)
        expect(input_dt.minute).to eq(30)
      end
    end

    context 'with ISO 8601 string' do
      it 'parses ISO 8601 datetime string' do
        input_dt = described_class.new('2024-03-15T14:30:00')

        expect(input_dt.year).to eq(2024)
        expect(input_dt.month).to eq(3)
        expect(input_dt.day).to eq(15)
        expect(input_dt.hour).to eq(14)
        expect(input_dt.minute).to eq(30)
      end
    end

    context 'with hash' do
      it 'parses datetime hash' do
        input_dt = described_class.new(
          year: 2024,
          month: 3,
          day: 15,
          hour: 14,
          minute: 30
        )

        expect(input_dt.year).to eq(2024)
        expect(input_dt.month).to eq(3)
        expect(input_dt.day).to eq(15)
        expect(input_dt.hour).to eq(14)
        expect(input_dt.minute).to eq(30)
      end

      it 'defaults hour, minute, second to 0 if not provided' do
        input_dt = described_class.new(year: 2024, month: 3, day: 15)

        expect(input_dt.hour).to eq(0)
        expect(input_dt.minute).to eq(0)
        expect(input_dt.second).to eq(0)
      end

      it 'raises error if required fields are missing' do
        expect {
          described_class.new(year: 2024, month: 3)
        }.to raise_error(RubyChartEngine::Error)
      end
    end
  end

  describe '#to_julian_day' do
    it 'converts datetime to Julian Day Number' do
      input_dt = described_class.new('2024-03-15T12:00:00')
      jd = input_dt.to_julian_day

      # JD for 2024-03-15 12:00:00 UTC should be around 2460387.0
      expect(jd).to be_within(1).of(2460387.0)
    end
  end
end
