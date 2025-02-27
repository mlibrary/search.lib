module Search
  module Presenters
    class Affiliation
      def initialize(affiliation)
        @affiliation = affiliation
      end

      def id
        @affiliation["id"]
      end

      def name
        @affiliation["name"]
      end

      def active
        @affiliation["active"]
      end

      def affiliation_text
        (active ? "Current" : "Choose") + " campus affiliation:"
      end

      def affiliation_class
        active ? "affiliation_active" : nil
      end
    end

    class Affiliations
      AFFILIATIONS = YAML.load_file(File.join(S.config_path, "affiliations.yaml")).map do |data|
        Affiliation.new(data)
      end

      include Enumerable

      def initialize(uri:)
        @uri = uri
        @affiliations = AFFILIATIONS
      end

      def each(&block)
        affiliations.each do |affiliation|
          block.call(affiliation)
        end
      end

      def find(active)
        affiliations.find { |x| x.active == active }
      end

      def default
        # first or patron affiliation
        @patron.affiliation || all.first
      end

      def set_active
        # (params || default).active = true
      end

      def active_affiliation
        find(true)
      end

      def inactive_affiliation
        find(false)
      end

      def set_default_library
        Search::Libraries.default(active_affiliation.id)
      end

      def search_only?
        @uri.path.split("/").last == "advanced"
      end

      def params
        if !@uri.query.nil?
          URI.decode_www_form(@uri.query)&.to_h || {}
        else
          {}
        end
      end

      def change_affiliation_url
        URI.encode_www_form("affiliation" => inactive_affiliation.id)
      end
    end
  end
end
