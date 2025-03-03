RSpec.describe "requests" do
  context "session setting" do
    before(:each) do
      @session = {
        email: "email",
        sms: "sms",
        logged_in: false,
        expires_at: (Time.now + 1.hour).to_i,
        campus: nil
      }
    end
    let(:get_static_page) {
      env "rack.session", @session
      get "/accessibility?something=other"
    }
    context "Logged in User" do
      it "does not touch the session when unexpired" do
        @session[:logged_in] = true
        get_static_page
        expect(last_request.session[:logged_in]).to eq(true)
        expect(last_request.session[:expires_at]).not_to be_nil
      end
    end
    context "Not Logged In User" do
      it "sets the session correctly for a new user" do
        @session = {}
        get_static_page
        expect(last_request.session[:logged_in]).to eq(false)
        expect(last_request.session[:expires_at]).not_to be_nil
        expect(last_request.session[:affiliation]).to be_nil
        expect(last_request.session[:path_before_form]).to include("/accessibility?something=other")
      end
      it "does not change the affiliation when unexpired" do
        @session[:affiliation] = "flint"
        get_static_page
        expect(last_request.session[:expires_at]).not_to be_nil
        expect(last_request.session[:affiliation]).to eq("flint")
        expect(last_request.session[:path_before_form]).to include("/accessibility?something=other")
      end
      it "resets the affiliation when expired" do
        @session[:affiliation] = "flint"
        @session[:expires_at] = (Time.now - 1.hour).to_i
        get_static_page
        expect(last_request.session[:expires_at]).not_to be_nil
        expect(last_request.session[:affiliation]).to be_nil
        expect(last_request.session[:path_before_form]).to include("/accessibility?something=other")
      end
    end
  end
  context "/" do
    it "redirects to /everything" do
      get "/"
      expect(last_response.status).to eq(302)
      # TODO: this is too fuzzy a test
      expect(last_response.location).to include("everything")
    end
  end
  context "/everything" do
    it "has a title and icons" do
      get "/everything"
      expect(last_response.body).to include("Everything")
      expect(last_response.body).to include("open_in_new")
    end
  end
end
