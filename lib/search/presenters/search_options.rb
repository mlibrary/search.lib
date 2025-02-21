module Search
  module Presenters
    class SearchOptions
      SEARCH_OPTIONS = YAML.load_file(File.join(S.config_path, "search_options.yaml"))

      def initialize(datastore)
        # selects options
      end

      def datastore_options
        # filtered options
      end

      def show_optgroups?
        # check if more than one group
      end

      def default_option
        # get first option
      end

      def selected_option
        # select option on load
      end

      def search_only
        # grab only `search` group options (used in advanced search)
      end
    end

    class SearchOption
      def initialize(option)
        @option = option
      end

      def value
        @option["value"]
      end

      def id
        @option["id"] || value
      end

      def text
        @option["text"]
      end

      def group
        @option["group"]
      end

      def tip
        @option["tip"]
      end

      def tip_label
        group.capitalize + " Tip:"
      end
    end
  end
end
