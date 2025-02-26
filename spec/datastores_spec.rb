# RSpec.describe Search::Presenters::Datastores do
#   context "#sdatastores" do
#     it "lists datastores in the config file" do
#       expect(described_class.new.datastores).to include("...")
#     end
#   end
# end

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
end
