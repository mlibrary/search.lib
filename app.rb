require "sinatra"
require "puma"

get "/" do
  redirect to("/everything")
end

get "/everything" do
  erb "Hello World"
end

not_found do
  status 404
  erb :"errors/404"
end
