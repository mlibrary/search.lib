require "sinatra"
require "puma"
require "ostruct"
require_relative "lib/services"
require_relative "lib/search"

datastores = Search::Presenters.datastores

before do
  @current_datastore = datastores.find { |datastore| datastore[:slug] == request.path_info.split("/")[1] }
  @datastores = datastores
  @patron = OpenStruct.new(
    email: "",
    sms: "",
    affiliation: "aa", # flint || aa
    logged_in?: false
  )
end

get "/" do
  redirect to("/everything")
end

helpers do
  def h1(body:, classes: nil)
    class_attribute = classes ? "class=\"#{classes.compact.join(" ")}\"" : nil
    attributes = [
      "id=\"maincontent\"",
      "tabindex=\"-1\"",
      class_attribute
    ].compact
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
end

datastores.each do |datastore|
  get "/#{datastore[:slug]}" do
    @presenter = Search::Presenters.for_datastore(datastore[:slug])
    erb :"datastores/layout", layout: :layout do
      erb :"datastores/#{datastore[:slug]}"
    end
  end
end

Search::Presenters.static_pages.each do |page|
  get "/#{page[:slug]}" do
    @presenter = Search::Presenters.for_static_page(page[:slug])
    erb :"pages/layout", layout: :layout do
      erb :"pages/#{page[:slug]}"
    end
  end
end

not_found do
  @presenter = Search::Presenters.for_404_page
  status 404
  erb :"errors/404"
end
