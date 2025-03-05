module Search
  class Library
    def initialize(library)
      @library = library
    end

    def active_class(param:, current_affiliation: nil)
      if matches_param?(param) ||
          (
            param.nil? &&
            (matches_current_affiliation?(current_affiliation) || matches_default?(current_affiliation))
          )
        "button__ghost--active"
      end
    end

    def slug
      @library.tr(" ", "+")
    end

    def to_s
      @library
    end

    def name
      @library
    end

    def matches_param?(param)
      @library == param
    end

    def matches_current_affiliation?(current_affiliation)
      current_affiliation == "flint" && name == "Flint Thompson Library"
    end

    def matches_default?(current_affiliation)
      current_affiliation.nil? && @library == Search::Libraries.default.name
    end
  end

  module Libraries
    LIBRARIES = YAML.load_file(File.join(S.config_path, "libraries.yaml")).map do |data|
      Library.new(data)
    end

    class << self
      include Enumerable

      def all
        LIBRARIES
      end

      def each(&block)
        all.each do |library|
          block.call(library)
        end
      end

      def default
        all.first
      end
    end
  end
end
