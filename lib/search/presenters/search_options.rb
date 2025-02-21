module Search
  module Presenters
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

    class BaseSearchOptions
      SEARCH_OPTIONS = YAML.load_file(File.join(S.config_path, "search_options.yaml")).map do |data|
        SearchOption.new(data)
      end
      DATASTORES = YAML.load_file(File.join(S.config_path, "datastores.yaml"))

      def initialize(slug)
        @datastore = DATASTORES.find { |x| x["slug"] == slug }
      end

      def datastore
        @datastore["slug"]
      end

      def options
        base_options.chunk_while do |elt_before, elt_after|
          elt_before.group == elt_after.group
        end.to_a.map do |group|
          OpenStruct.new(
            optgroup: group.first.group,
            options: group
          )
        end
      end

      def base_options
        # filtered options
        @datastore["search_options"].map do |id|
          SEARCH_OPTIONS.find { |x| x.id == id }
        end
      end

      def show_optgroups?
        # check if more than one group
        options.count > 1
      end

      def default_option
        # get first option
        base_options.first
      end

      # def selected_option
      #   # select option on load
      # end

      # def search_only
      #   # grab only `search` group options (used in advanced search)
      # end
    end

    class SearchOptions
      ALL_BASE_SEARCH_OPTIONS = YAML.load_file(File.join(S.config_path, "datastores.yaml")).map do |datastore|
        BaseSearchOptions.new(datastore["slug"])
      end

      def initialize(datastore_slug:, uri:)
        @uri = uri
        @datastore_slug = datastore_slug
      end

      def base_search_options
        ALL_BASE_SEARCH_OPTIONS.find { |x| x.datastore == @datastore_slug }
      end

      # select option on load
      def selected_option
        base_options = base_search_options.base_options
        my_option = base_options.first

        full_option_value_from_query = params["query"]
        option_value_from_query = full_option_value_from_query&.split(":(")&.first

        if !option_value_from_query.nil?
          found_option = base_options.find { |option| option.value == option_value_from_query }
          my_option = found_option unless found_option.nil?
        end
        my_option.value
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
    end
  end
end
