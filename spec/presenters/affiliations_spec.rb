RSpec.describe Search::Presenters::Affiliations do
  before(:each) do
    @params = {
      uri: URI.parse("/page"),
      current_affiliation: "aa"
    }
  end

  subject do
    described_class.new(**@params)
  end

  context "#each" do
    it "iterates over the affiliations with names" do
      affiliation_names = []
      subject.each do |affiliation|
        affiliation_names << affiliation.name
      end

      expect(affiliation_names).to contain_exactly("Ann Arbor", "Flint")
    end
  end

  context "aa is current_affiliation" do
    context "#active_affiliation" do
      it "returns ann arbor" do
        expect(subject.active_affiliation.id).to eq("aa")
      end
    end
    context "#inactive_affiliation" do
      it "returns flint" do
        expect(subject.inactive_affiliation.id).to eq("flint")
      end
    end
  end
  context "flint is current_affiliation" do
    before(:each) do
      @params[:current_affiliation] = "flint"
    end
    context "#active_affiliation" do
      it "returns flint" do
        expect(subject.active_affiliation.id).to eq("flint")
      end
    end
    context "#inactive_affiliation" do
      it "returns aa" do
        expect(subject.inactive_affiliation.id).to eq("aa")
      end
    end
  end
end

RSpec.describe Search::Presenters::Affiliation do
  before(:each) do
    @params = {
      data: {
        "id" => "aa",
        "name" => "Ann Arbor"
      },
      current_affiliation: "aa"

    }
  end

  subject do
    described_class.new(**@params)
  end

  context "#id" do
    it "has an id" do
      expect(subject.id).to eq(@params[:data]["id"])
    end
  end

  context "#name" do
    it "has a name" do
      expect(subject.name).to eq(@params[:data]["name"])
    end
  end

  context "#to_s" do
    it "returns the name" do
      expect(subject.to_s).to eq(@params[:data]["name"])
    end
  end

  context "current afilliation matches the id" do
    context "#active?" do
      it "is true" do
        expect(subject.active?).to eq(true)
      end
    end
    context "#screen_reader_text" do
      it "is 'Current'" do
        expect(subject.screen_reader_text).to eq("Current campus affiliation:")
      end
    end
    context "#class" do
      it "is 'affiliation_active'" do
        expect(subject.class).to eq("affiliation_active")
      end
    end
  end
  context "current afilliation does not match the id" do
    before(:each) do
      @params[:current_affiliation] = "flint"
    end
    context "#active?" do
      it "is false" do
        expect(subject.active?).to eq(false)
      end
    end
    context "#screen_reader_text" do
      it "is 'Choose'" do
        expect(subject.screen_reader_text).to eq("Choose campus affiliation:")
      end
    end
    context "#class" do
      it "is nil" do
        expect(subject.class).to be_nil
      end
    end
  end
end
