require "sinatra"
require "puma"
require "ostruct"
require_relative "lib/services"

before do
  @presenter = OpenStruct.new(title: "PLACEHOLDER_TITLE", icons: "dashboard,open_in_new,search")
end

get "/" do
  redirect to("/everything")
end

[
  {slug: "everything", title: "Everything"},
  {slug: "catalog", title: "Catalog"},
  {slug: "articles", title: "Articles"},
  {slug: "databases", title: "Databases"},
  {slug: "onlinejournals", title: "Online Journals"},
  {slug: "guidesandmore", title: "Guides and More"}
].each do |datastore|
  get "/#{datastore[:slug]}" do
    @presenter.title = datastore[:title]
    erb :"datastores/layout", layout: :layout do
      erb :"datastores/#{datastore[:slug]}"
    end
  end
end

[
  {slug: "about-library-search", title: "About Library Search"},
  {slug: "accessibility", title: "Accessibility"}
].each do |page|
  get "/#{page[:slug]}" do
    @presenter.title = page[:title]
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
