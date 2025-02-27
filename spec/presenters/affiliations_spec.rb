RSpec.describe Search::Presenters::Affiliations do
  before(:each) do
    @uri = URI.parse("/page")
  end

  subject do
    described_class.new(uri: @uri)
  end

  context "#each" do
    it "iterates over the affiliations with names" do
      affiliation_names = []
      described_class.each do |affiliation|
        affiliation_names << affiliation.name
      end

      expect(affiliation_names).to contain_exactly("Ann Arbor", "Flint")
    end
  end

  context "#active_affiliation" do
    it "grabs the current active affiliation" do
      expect(subject.active_affiliation).to contain_exactly("Ann Arbor", "Flint")
    end
  end

  context "#inactive_affiliation" do
    it "grabs the current inactive affiliation" do
      expect(subject.inactive_affiliation).to contain_exactly("Ann Arbor", "Flint")
    end
  end
end

RSpec.describe Search::Presenters::Affiliation do
  before(:each) do
    @affiliation = {
      "id" => "aa",
      "name" => "Ann Arbor",
      "active" => false
    }
  end

  subject do
    described_class.new(@affiliation)
  end

  context "#id" do
    it "has an id" do
      expect(subject.id).to eq(@affiliation["id"])
    end
  end

  context "#name" do
    it "has a name" do
      expect(subject.name).to eq(@affiliation["name"])
    end
  end

  context "#active" do
    it "shows if active" do
      expect(subject.active).to eq(false)
    end
  end

  context "#affiliation_text" do
    it "communicates to choose if inactive" do
      expect(subject.affiliation_text).to eq("Choose campus affiliation:")
    end
    it "communicates it is current if active" do
      @affiliation["active"] = true
      expect(subject.affiliation_text).to eq("Current campus affiliation:")
    end
  end
end
