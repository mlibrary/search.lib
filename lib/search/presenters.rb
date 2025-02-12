module Search
  module Presenters
  end
end
require "search/presenters/icons"

module Search::Presenters
  def self.datastores
    [
      {slug: "everything", title: "Everything"},
      {slug: "catalog", title: "Catalog"},
      {slug: "articles", title: "Articles"},
      {slug: "databases", title: "Databases"},
      {slug: "onlinejournals", title: "Online Journals"},
      {slug: "guidesandmore", title: "Guides and More"}
    ]
  end

  def self.static_pages
    [
      {slug: "about-library-search", title: "About Library Search"},
      {slug: "accessibility", title: "Accessibility"}
    ]
  end

  def self.for_datastore(slug)
    datastore = datastores.find { |x| x[:slug] == slug }

    OpenStruct.new(
      title: datastore[:title],
      icons: Icons.new,
      styles: ["styles.css", "datastores/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js", "datastores/partials/scripts.js"]
    )
  end

  def self.for_static_page(slug)
    page = static_pages.find { |x| x[:slug] == slug }

    OpenStruct.new(
      title: page[:title],
      icons: Icons.new,
      styles: ["styles.css", "pages/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js"]
    )
  end
end
