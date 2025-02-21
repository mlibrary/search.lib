module Search
  module Presenters
    class Datastores
      DATASTORES = YAML.load_file(File.join(S.config_path, "datastores.yaml"))

      def initialize(datastores = [])
        @datastores = datastores
      end
    end

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
    end
  end
end
