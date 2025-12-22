module Astrolith
  module Serializers
    class JsonSerializer
      def self.serialize(chart)
        chart.to_hash.to_json
      end

      def self.serialize_pretty(chart)
        JSON.pretty_generate(chart.to_hash)
      end

      # Serialize multiple charts
      def self.serialize_collection(charts)
        charts.map(&:to_hash).to_json
      end

      # Serialize with custom options
      def self.serialize_with_options(chart, options = {})
        data = chart.to_hash

        # Apply filters if specified
        if options[:include]
          data = data.select { |k, _| options[:include].include?(k) }
        end

        if options[:exclude]
          data = data.reject { |k, _| options[:exclude].include?(k) }
        end

        # Format output
        if options[:pretty]
          JSON.pretty_generate(data)
        else
          data.to_json
        end
      end

      # Parse JSON back to hash
      def self.deserialize(json_string)
        JSON.parse(json_string, symbolize_names: true)
      end
    end
  end
end
