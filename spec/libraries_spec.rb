RSpec.describe Search::Library do
  before(:each) do
    @library = "Flint Thompson Library"
  end

  subject do
    described_class.new(@library)
  end

  context "#active_class" do
    it "will return a class if the `library` query params matches the library" do
      expect(subject.active_class(param: @library)).to eq("button__ghost--active")
    end
    it "will not return a class if the `library` query params does not match the library nor does the current_affiliation" do
      expect(subject.active_class(param: "library")).to be_nil
    end
    context "when param is nil" do
      context "when current_affiliation is nil" do
        it "will return a class for the default library" do
          @library = "All libraries"
          expect(subject.active_class(param: nil)).to eq("button__ghost--active")
        end
        it "will return nil for anything else" do
          expect(subject.active_class(param: nil)).to be_nil
        end
      end
      context "when current_affiliation is flint" do
        it "will return a class for the Flint library when the current_affiliation is flint" do
          expect(subject.active_class(param: nil, current_affiliation: "flint")).to eq("button__ghost--active")
        end
        it "will not return a class for the default library" do
          @library = "All libraries"
          expect(subject.active_class(param: nil, current_affiliation: "flint")).to be_nil
        end
      end
    end
  end

  context "#slug" do
    it "has a slug" do
      expect(subject.slug).to eq("Flint+Thompson+Library")
    end
  end

  context "#to_s" do
    it "returns as a string" do
      expect(subject.to_s).to eq(@library)
    end
  end
end

RSpec.describe Search::Libraries do
  let(:library) { "All libraries" }

  context "#all" do
    it "lists all libraries in the config file" do
      expect(described_class.all.first.to_s).to eq(library)
    end
  end

  context "#each" do
    it "loops through each library" do
      libraries = []
      described_class.each do |library|
        libraries << library.to_s
      end

      expect(libraries).to eq(["All libraries", "U-M Ann Arbor Libraries", "Flint Thompson Library", "Bentley Historical Library", "William L. Clements Library"])
    end
  end

  context "#default" do
    it "returns the default library" do
      expect(described_class.default.to_s).to eq(library)
    end
  end
end
