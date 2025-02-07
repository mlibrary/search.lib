require "sinatra"
require "puma"
require "ostruct"
require_relative "lib/services"

get "/" do
  redirect to("/everything")
end

get "/everything" do
  presenter = OpenStruct.new(title: "PLACEHOLDER_TITLE", icons: ["dashboard", "open_in_new", "search"])
  erb :"datastores/everything", locals: {presenter: presenter}
end

# Read all files in views/pages to automatically create routes
Dir.glob("views/pages/*.erb").each do |file|
  page = File.basename(file, ".erb")
  next if page == "layout" # Exclude the layout from being treated as a route
  get "/#{page}" do
    erb :"pages/layout", layout: :layout do
      erb :"pages/#{page}"
    end
  end
end

not_found do
  status 404
  erb :"errors/404"
end
