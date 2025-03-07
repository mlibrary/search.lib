require "sinatra/base"
require_relative "search"
module Sinatra
  module SearchHelpers
    include Search::ViewHelpers
  end
  helpers SearchHelpers
end
