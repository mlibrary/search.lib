module Search
  module Presenters
    class Datastore
      def initialize(datastore)
        @datastore = datastore
      end

      def slug
        @datastore["slug"]
      end

      def title
        @datastore["title"]
      end

      def description
        @datastore["description"]
      end

      def search_options
        @datastore["search_options"]
      end

      def aria_current_attribute(presenter_slug)
        (slug == presenter_slug) ? "page" : "false"
      end
    end

    class Datastores
      DATASTORES = YAML.load_file(File.join(S.config_path, "datastores.yaml"))

      def initialize(datastores = [])
        @datastores = datastores
      end
    end
  end
end
