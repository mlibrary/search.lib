require "spec_helper"
RSpec.describe "requests" do
  context "/" do
    it "redirects to /everything" do
      get "/"
      expect(last_response.status).to eq(302)
      # TODO: this is too fuzzy a test
      expect(last_response.location).to include("everything")
    end
  end
  context "/everything" do
    it "has a title" do
      get "/everything"
      expect(last_response.body).to include("PLACEHOLDER TITLE")
    end
  end
end
