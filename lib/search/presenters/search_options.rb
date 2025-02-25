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
        flat_list.chunk_while do |elt_before, elt_after|
          elt_before.group == elt_after.group
        end.to_a.map do |group|
          OpenStruct.new(
            optgroup: group.first.group,
            options: group
          )
        end
      end

      def flat_list
        # filtered options
        @datastore["search_options"].map do |id|
          SEARCH_OPTIONS.find { |x| x.id == id }
        end
      end

      def default_option
        # get first option
        flat_list.first
      end

      def optgroups?
        options.count > 1
      end
    end

    class SearchOptions
      ALL_BASE_SEARCH_OPTIONS = YAML.load_file(File.join(S.config_path, "datastores.yaml")).map do |datastore|
        BaseSearchOptions.new(datastore["slug"])
      end

      include Enumerable

      def initialize(datastore_slug:, uri:)
        @uri = uri
        @datastore_slug = datastore_slug
      end

      def base_search_options
        ALL_BASE_SEARCH_OPTIONS.find { |x| x.datastore == @datastore_slug }
      end

      def flat_list
        base_search_options.flat_list
      end

      def options
        if search_only? || !show_optgroups?
          base_search_options.options.first.options
        else
          base_search_options.options
        end
      end

      def each(&block)
        options.each do |group|
          block.call(group)
        end
      end

      def show_optgroups?
        # check if more than one group
        base_search_options.optgroups? && !search_only?
      end

      def selected_attribute(value)
        (value == selected_option) ? "selected" : ""
      end

      # TODO: Needs to account for Booleans and return default when there's a boolean
      # select option on load
      def selected_option
        my_option = base_search_options.default_option

        full_option_value_from_query = params["query"]
        return my_option.value if ["AND", "OR", "NOT"].any? { |x| full_option_value_from_query&.match?(x) }

        option_value_from_query = full_option_value_from_query&.split(":(")&.first

        if !option_value_from_query.nil?
          found_option = flat_list.find { |option| option.value == option_value_from_query }
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
