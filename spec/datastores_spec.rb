RSpec.describe Search::Datastore do
  before(:each) do
    @datastore = {
      "slug" => "everything",
      "title" => "Everything",
      "description" => "Explore the University of Michigan Library Search for comprehensive results across catalogs, articles, databases, online journals, and more. Begin your search now for detailed records and specific resources.",
      "search_options" => ["keyword", "title", "author"]
    }
  end

  subject do
    described_class.new(@datastore)
  end

  context "#slug" do
    it "has a slug" do
      expect(subject.slug).to eq(@datastore["slug"])
    end
  end

  context "#title" do
    it "has a title" do
      expect(subject.title).to eq(@datastore["title"])
    end
  end

  context "#description" do
    it "has a description" do
      expect(subject.description).to eq(@datastore["description"])
    end
  end

  context "#search_options" do
    it "has search options" do
      expect(subject.search_options).to eq(@datastore["search_options"])
    end
  end

  context "#aria_current_attribute()" do
    it "returns \"page\" if the presenter's slug matches the datastore slug" do
      expect(subject.aria_current_attribute("everything")).to eq("page")
    end
    it "returns \"false\" if the presenter's slug does not match the datastore slug" do
      expect(subject.aria_current_attribute("accessibility")).to eq("false")
    end
  end
end

RSpec.describe Search::Datastores do
  context "#all" do
    it "lists datastores in the config file" do
      expect(described_class.all.first.slug).to include("everything")
    end
  end

  context "#find()" do
    it "finds and returns the object by slug" do
      expect(described_class.find("guidesandmore").slug).to eq("guidesandmore")
    end
  end

  context "#default" do
    it "returns the default object (everything)" do
      expect(described_class.default.slug).to eq("everything")
    end
  end
end
