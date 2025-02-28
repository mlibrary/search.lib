module Search
  class Library
    def initialize(library)
      @library = library
    end

    def active_class(param)
      "button__ghost--active" if (@library == param || (param.nil? && self.to_s == Search::Libraries.default.to_s))
    end

    def slug
      @library.tr(" ", "+")
    end

    def to_s
      @library
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
