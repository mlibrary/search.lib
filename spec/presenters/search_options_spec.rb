RSpec.describe Search::Presenters::SearchOptions do
  before(:each) do
    @uri = URI.parse("/everything")
    @datastore_slug = "everything"
  end
  subject do
    described_class.new(uri: @uri, datastore_slug: @datastore_slug)
  end

  context "selected_option" do
    it "chooses the value of the default option if nothing is specified" do
      expect(subject.selected_option).to eq("keyword")
    end
    it "chooses the appropriate option based on the query parameters" do
      @uri = URI.parse("/catalog?query=lc_subject_starts_with%3A(whatever)")
      @datastore_slug = "catalog"
      expect(subject.selected_option).to eq("lc_subject_starts_with")
    end
    it "choose the default option if the datastore does not have a matching option" do
      @uri = URI.parse("/something_else?query=lc_subject_starts_with%3A(whatever)")
      expect(subject.selected_option).to eq("keyword")
    end
    context "choose the default for a boolean" do
      it "AND" do
        @uri = URI.parse("/catalog?query=title%3A(test)+AND+author%3A(test)")
        expect(subject.selected_option).to eq("keyword")
      end
      it "OR" do
        @uri = URI.parse("/catalog?query=title%3A(test)+OR+author%3A(test)")
        expect(subject.selected_option).to eq("keyword")
      end
      it "NOT" do
        @uri = URI.parse("/catalog?query=title%3A(test)+NOT+author%3A(test)")
        expect(subject.selected_option).to eq("keyword")
      end
    end
  end
  context "search_only?" do
    it "is false when the path is not advanced search" do
      expect(subject.search_only?).to eq(false)
    end
    it "is true when that path has a subdirectory of advanced search" do
      @uri = URI.parse("/catalog/advanced")
      expect(subject.search_only?).to eq(true)
    end
  end
  context "options" do
    it "returns multiple opt groups when not search only" do
      @datastore_slug = "catalog"
      expect(subject.options.count).to eq(2)
    end
    it "returns only one opt group when search only" do
      @uri = URI.parse("/catalog/advanced")
      @datastore_slug = "catalog"
      expect(subject.options.count).to eq(1)
    end
  end
  context "#show_optgroups?" do
    it "is true when there is more than one opt group" do
      @datastore_slug = "catalog"
      expect(subject.show_optgroups?).to eq(true)
    end
    it "is false when there is only one opt group" do
      @uri = URI.parse("/catalog/advanced")
      @datastore_slug = "catalog"
      expect(subject.show_optgroups?).to eq(false)
    end
  end

  context "#each" do
    it "iterates over the options" do
      output = nil
      subject.each do |group|
        output = group.optgroup
      end

      expect(output).to eq("search")
    end
  end
end
RSpec.describe Search::Presenters::BaseSearchOptions do
  before(:each) do
    @slug = "everything"
  end
  subject do
    described_class.new(@slug)
  end
  context "#default_option" do
    it "returns the first option in the list" do
      expect(subject.default_option.text).to eq("Keyword")
    end
  end

  context "#options" do
    it "returns an array with one object when there is one group" do
      options = subject.options
      expect(options.count).to eq(1)
      expect(options.first.optgroup).to eq("search")
      expect(options.first.options.first.text).to eq("Keyword")
    end
    it "returns an array of arrays when there are multiple groups" do
      @slug = "catalog"
      options = subject.options
      expect(options.count).to eq(2)
      expect(options[1].optgroup).to eq("browse")
      expect(options[1].options.first.text).to include("Browse")
    end
  end

  #   context "#datastore_search_options" do
  #     it "lists search options specific to the datastore" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #     it "defaults to the first datastore if datastore is nil" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #   end

  #   context "#datastore_search_tips" do
  #     it "lists search tips specific to the datastore search options" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #   end

  #   context "#show_optgroups?" do
  #     it "checks if there is more than one group of search options" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #   end

  #   context "#default_option" do
  #     it "gives the first search option specific to the datastore" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #   end

  #   context "#queried_option" do
  #     it "lists search options specific to the datastore" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #     it "defaults to the first option if queried option does not exist" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #     it "defaults to the first option if the query contains operators" do
  #       expect(described_class.new.datastore_search_options).to include("...")
  #     end
  #   end
end

RSpec.describe Search::Presenters::SearchOption do
  before(:each) do
    @search_option = {
      "id" => "keyword_contains",
      "value" => "keyword",
      "text" => "Keyword (contains)",
      "tip" => "Enter one or more keywords to search broadly (e.g., Black Women Scientists). Use quotes to search for a specific phrase (e.g., \"systems of oppression\"). See tips about <a href=\"https://guides.lib.umich.edu/c.php?g=914690&p=6590011?utm_source=library-search\" class=\"open-in-new\" target=\"_blank\" rel=\"noopener noreferrer\" aria-label=\"Basic Keyword Searching - opens in new window\">Basic Keyword Searching</a>.",
      "group" => "search"
    }
  end

  subject do
    described_class.new(@search_option)
  end

  context "#value" do
    it "has a value" do
      expect(subject.value).to eq(@search_option["value"])
    end
  end

  context "#id" do
    it "grabs `id` if it exists" do
      expect(subject.id).to eq(@search_option["id"])
    end
    it "defaults to value" do
      @search_option.delete("id")
      expect(subject.id).to eq(@search_option["value"])
    end
  end

  context "#text" do
    it "has a text" do
      expect(subject.text).to eq(@search_option["text"])
    end
  end

  context "#group" do
    it "has a group" do
      expect(subject.group).to eq(@search_option["group"])
    end
  end

  context "#tip" do
    it "has a tip" do
      expect(subject.tip).to eq(@search_option["tip"])
    end
  end

  context "#tip_label" do
    it "has a tip_label" do
      expect(subject.tip_label).to eq("Search Tip:")
    end
  end
end
