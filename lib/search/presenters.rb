module Search
  module Presenters
  end
end
require "search/presenters/icons"

module Search::Presenters
  def self.everything
    OpenStruct.new(icons: Icons.new, title: "PLACEHOLDER_TITLE")
  end
end
