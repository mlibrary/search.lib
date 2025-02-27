require "sinatra"
require "puma"
require "yabeda"
require "ostruct"
require_relative "lib/services"
require_relative "lib/search"

Yabeda.configure do
  group :search_app do
    counter :datastore_request_count, comment: "Total number of requests to a datastore", tags: %i[datastore]
    # gauge :whistles_active, comment: "Number of whistles ready to whistle"
    # histogram :whistle_runtime do
    #   comment "How long whistles are being active"
    #   unit :seconds
    # end
    #  summary :bells_ringing_duration, unit: :seconds, comment: "How long bells are ringing"
  end
end

Yabeda.configure!

enable :sessions
set :session_secret, S.session_secret
S.logger.info("App Environment: #{settings.environment}")
S.logger.info("Log level: #{S.log_level}")

before do
  subdirectory = request.path_info.split("/")[1]

  pass if ["auth", "logout", "login", "-"].include?(subdirectory)
  pass if subdirectory == "session_switcher" && S.dev_login?

  if new_user? || expired_user_session?
    patron = Search::Patron.not_logged_in
    patron.to_h.each { |k, v| session[k] = v }
    session.delete(:expires_at)
  end
  @patron = Search::Patron.from_session(session)

  session[:path_before_login] = request.url

  S.logger.debug("here's the session", session.to_h)
  @datastores = Search::Datastores.all
end

if S.dev_login?
  get "/session_switcher" do
    patron = Search::Patron.for(params[:uniqname])
    patron.to_h.each { |k, v| session[k] = v }
    session[:expires_at] = (Time.now + 1.day).to_i
    redirect back
  end
end

helpers do
  #
  # A new user is someone who doesn't have any session variables set.
  #
  # @return [Boolean]
  #
  def new_user?
    session[:logged_in].nil?
  end

  #
  # A session state where logged_in is true and expires_at is in the past
  #
  # @return [Boolean] <description>
  #
  def expired_user_session?
    session[:logged_in] && session[:expires_at] < Time.now.to_i
  end
end

get "/" do
  redirect to("/everything")
end

helpers do
  def h1(body:, classes: [], rest: nil)
    attributes = [
      "id=\"maincontent\"",
      "tabindex=\"-1\"",
      rest
    ].compact

    if !classes.empty?
      attributes << "class=\"#{classes.compact.join(" ")}\""
    end

    "<h1 #{attributes.join(" ")}>#{body}</h1>"
  end

  def link_to(body:, url:, classes: [], open_in_new: false, utm_source: "library-search", rest: nil)
    uri = URI.parse(url)

    if ["http", "https"].include?(uri.scheme) && !uri.host.nil? && uri.host != request.host
      params = URI.decode_www_form(uri.query || "") + {utm_source: utm_source}.to_a
      uri.query = URI.encode_www_form(params)
    end

    attributes = [
      "href=\"#{uri}\"",
      rest
    ].compact

    if open_in_new
      attributes << "target=\"_blank\" rel=\"noopener noreferrer\" aria-label=\"#{body} - opens in new window\""
      classes << "open-in-new"
    end
    if !classes.empty?
      attributes << "class=\"#{classes.compact.join(" ")}\""
    end

    "<a #{attributes.join(" ")}>#{body}</a>"
  end

  def login
    if @patron.logged_in?
      link_to(body: "Log out", url: "/logout", classes: ["underline__none"])
    else
      <<-HTML
        <form id="login_form" method="post" action="/auth/openid_connect">
          <input type="hidden" name="authenticity_token" value="#{request.env["rack.session"]["csrf"]}">
          <button type="submit">Log in</button>
        </form>
      HTML
    end
  end
end

Search::Datastores.each do |datastore|
  get "/#{datastore.slug}" do
    Yabeda.search_app.datastore_request_count.increment({datastore: datastore.slug}, by: 1)
    @presenter = Search::Presenters.for_datastore(slug: datastore.slug, uri: URI.parse(request.fullpath))
    erb :"datastores/layout", layout: :layout do
      erb :"datastores/#{datastore.slug}"
    end
  end
end

Search::Presenters.static_pages.each do |page|
  get "/#{page[:slug]}" do
    @presenter = Search::Presenters.for_static_page(slug: page[:slug], uri: URI.parse(request.fullpath))
    erb :"pages/layout", layout: :layout do
      erb :"pages/#{page[:slug]}"
    end
  end
end

not_found do
  @presenter = Search::Presenters.for_404_page(uri: URI.parse(request.fullpath))
  status 404
  erb :"errors/404"
end
