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
  def link_to(body:, url:, classes: nil, open_in_new: false, utm_source: "library-search")
    uri = URI.parse(url)
    if ["http", "https"].include?(uri.scheme) && !uri.host.nil?
      params = URI.decode_www_form(uri.query || "") + {utm_source: utm_source}.to_a
      uri.query = URI.encode_www_form(params)
    end
    class_string = nil
    if classes
      class_string = "class=\"#{classes.join(" ")}\""
    end
    elements = [
      "href=\"#{uri}\"",
      class_string
    ].compact

    if open_in_new
      <<~HTML
          <a #{elements.join(" ")} target="_blank" rel="noopener noreferrer" aria-label="#{body} - opens in new window">
          #{body}<span class="material-symbols-rounded" aria-hidden="true">open_in_new</span>
        </a>
      HTML
    else
      "<a #{elements.join(" ")}>#{body}</a>"
    end
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
  @presenter.title = "404 - Page not found"
  status 404
  erb :"errors/404"
end
