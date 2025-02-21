# RSpec.describe Search::Presenters::SearchOptions do
#   context "#search_options" do
#     it "lists search options in the config file" do
#       expect(described_class.new.search_options).to include("...")
#     end
#   end

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
# end

RSpec.describe Search::Presenters::SearchOption do
  context "#value" do
    it "has a value" do
      search_option = {
        "id" => "keyword_contains",
        "value" => "keyword",
        "text" => "Keyword (contains)",
        "tip" => "Enter one or more keywords to search broadly (e.g., Black Women Scientists). Use quotes to search for a specific phrase (e.g., \"systems of oppression\"). See tips about <a href=\"https://guides.lib.umich.edu/c.php?g=914690&p=6590011?utm_source=library-search\" class=\"open-in-new\" target=\"_blank\" rel=\"noopener noreferrer\" aria-label=\"Basic Keyword Searching - opens in new window\">Basic Keyword Searching</a>.",
        "group" => "search"
      }
      expect(described_class.new(search_option).value).to eq(search_option["value"])
    end
  end
end
