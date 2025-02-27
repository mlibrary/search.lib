module Search
  module Presenters
    class Affiliation
      def initialize(data:, current_affiliation:)
        @data = data
        @current_affiliation = current_affiliation
      end

      def id
        @data["id"]
      end

      def name
        @data["name"]
      end

      def to_s
        name
      end

      def active?
        @current_affiliation == id
      end

      def screen_reader_text
        (active? ? "Current" : "Choose") + " campus affiliation:"
      end

      def class
        active? ? "affiliation_active" : nil
      end

      def url
        "http://localhost:4567"
      end
    end

    class Affiliations
      AFFILIATIONS = YAML.load_file(File.join(S.config_path, "affiliations.yaml"))
      include Enumerable

      def initialize(uri:, current_affiliation:)
        @uri = uri
        @affiliations = AFFILIATIONS.map { |x| Affiliation.new(data: x, current_affiliation: current_affiliation) }
      end

      def each(&block)
        all.each do |affiliation|
          block.call(affiliation)
        end
      end

      def active_affiliation
        @affiliations.find { |x| x.active? }
      end

      def inactive_affiliation
        @affiliations.find { |x| !x.active? }
      end

      def all
        @affiliations
      end

      def params
        if !@uri.query.nil?
          URI.decode_www_form(@uri.query)&.to_h || {}
        else
          {}
        end
      end

      def url
        "http://localhost:4567"
      end

      # I think this should link to a route that can update the session.
      def change_affiliation_url
        "http://localhost:4567"
      end
    end
  end
end
