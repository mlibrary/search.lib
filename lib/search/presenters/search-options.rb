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
      def initialize
        #
      end

      def value
        #
      end

      def tip
        #
      end

      def tip_label
        #
      end

      def text
        #
      end

      def optgroup
        #
      end
    end
  end
end
