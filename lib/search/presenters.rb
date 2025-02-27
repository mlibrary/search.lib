module Search
  module Presenters
  end
end
require "search/presenters/icons"
require "search/presenters/search_options"

module Search::Presenters
  def self.static_pages
    [
      {
        description: "Experience the University of Michigan Library Search, a discovery interface offering seamless access to physical and electronic resources. Since 2018, it provides a unified user experience with comprehensive search capabilities across Catalogs, Articles, Databases, Online Journals, and Guides & More.",
        slug: "about-library-search",
        title: "About Library Search"
      },
      {
        description: "Committed to inclusivity, University of Michigan Library strives to make Library Search accessible and user-friendly for everyone, adhering to WCAG 2.1 AA standards to ensure optimal usability.",
        slug: "accessibility",
        title: "Accessibility"
      }
    ]
  end

  def self.for_datastore(slug:, uri:)
    datastore = Search::Datastores.find(slug)

    OpenStruct.new(
      title: datastore.title,
      current_datastore: slug,
      description: datastore.description,
      icons: Icons.new,
      slug: datastore.slug,
      styles: ["styles.css", "datastores/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js"],
      search_options: SearchOptions.new(datastore_slug: slug, uri: uri)
    )
  end

  def self.for_static_page(slug:, uri:)
    page = static_pages.find { |x| x[:slug] == slug }

    OpenStruct.new(
      title: page[:title],
      current_datastore: "everything",
      description: page[:description],
      icons: Icons.new,
      slug: page[:slug],
      styles: ["styles.css", "pages/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js"],
      search_options: SearchOptions.new(datastore_slug: "everything", uri: uri)
    )
  end

  def self.for_404_page(uri:)
    OpenStruct.new(
      title: "404 - Page not found",
      description: "Page not found (404) at University of Michigan Library. Return to the homepage, search by title/keyword, browse all Databases or Online Journals, or ask a librarian for assistance in locating resources.",
      icons: Icons.new,
      styles: ["styles.css", "pages/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js"],
      search_options: SearchOptions.new(datastore_slug: "everything", uri: uri)
    )
  end
end
