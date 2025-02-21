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

    class SearchOptions
      SEARCH_OPTIONS = YAML.load_file(File.join(S.config_path, "search_options.yaml")).map do |data|
        SearchOption.new(data)
      end
      DATASTORES = YAML.load_file(File.join(S.config_path, "datastores.yaml"))

      def initialize(slug)
        @datastore = DATASTORES.find { |x| x["slug"] == slug }
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

      def selected_option
        # select option on load
      end

      def search_only
        # grab only `search` group options (used in advanced search)
      end
    end
  end
end
