require "sinatra"
require "puma"
require "ostruct"
require_relative "lib/services"
require_relative "lib/search"

datastores = [
  {slug: "everything", title: "Everything"},
  {slug: "catalog", title: "Catalog"},
  {slug: "articles", title: "Articles"},
  {slug: "databases", title: "Databases"},
  {slug: "onlinejournals", title: "Online Journals"},
  {slug: "guidesandmore", title: "Guides and More"}
]

before do
  @current_datastore = datastores.find { |datastore| datastore[:slug] == request.path_info.split("/")[1] }
  @datastores = datastores
  @presenter = OpenStruct.new(
    title: "PLACEHOLDER_TITLE",
    icons: ["open_in_new"],
    styles: ["styles.css"],
    scripts: ["scripts.js", "partials/scripts.js"]
  )
end

get "/" do
  redirect to("/everything")
end

get "/everything" do
  @presenter = Search::Presenters.everything
  erb :"datastores/everything"
end

datastores.each do |datastore|
  get "/#{datastore[:slug]}" do
    @presenter.title = datastore[:title]
    @presenter.icons << ["dashboard", "info", "search"]
    @presenter.styles << "datastores/styles.css"
    @presenter.scripts << "datastores/partials/scripts.js"
    erb :"datastores/layout", layout: :layout do
      erb :"datastores/#{datastore[:slug]}"
    end
  end

[
  {slug: "about-library-search", title: "About Library Search"},
  {slug: "accessibility", title: "Accessibility"}
].each do |page|
  get "/#{page[:slug]}" do
    @presenter.title = page[:title]
    @presenter.styles << "pages/styles.css"
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
