module Search
  module Presenters
    class Affiliation
      attr_reader :name

      def initialize(name:, current_affiliation:)
        @name = name
        @current_affiliation = current_affiliation
      end

      def to_s
        name
      end

      def not_flint?
        name != "Flint"
      end

      def active?
        not_flint? && @current_affiliation.nil? ||
          @current_affiliation == name.downcase
      end

      def screen_reader_text
        (active? ? "Current" : "Choose") + " campus affiliation:"
      end

      def class
        active? ? "affiliation__active" : nil
      end

      def url
        "http://localhost:4567"
      end
    end

    class Affiliations
      AFFILIATIONS = ["Ann Arbor", "Flint"]
      include Enumerable

      def initialize(current_affiliation:)
        @affiliations = AFFILIATIONS.map { |x| Affiliation.new(name: x, current_affiliation: current_affiliation) }
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
