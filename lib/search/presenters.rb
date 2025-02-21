module Search
  module Presenters
  end
end
require "search/presenters/icons"

module Search::Presenters
  def self.datastores
    [
      {
        description: "Explore the University of Michigan Library Search for comprehensive results across catalogs, articles, databases, online journals, and more. Begin your search now for detailed records and specific resources.",
        slug: "everything",
        title: "Everything",
        search_options: [
          "keyword",
          "title",
          "author"
        ]
      },
      {
        description: "Discover the University of Michigan Library Catalog to access an extensive collection of physical and online materials, including books, audio, video, maps, musical scores, and more. Find everything you need in one place.",
        slug: "catalog",
        title: "Catalog",
        search_options: [
          "keyword",
          "title",
          "title_starts_with",
          "author",
          "journal_title",
          "subject",
          "lc_subject_starts_with",
          "call_number_starts_with",
          "series",
          "isn",
          "browse_by_callnumber",
          "browse_by_author",
          "browse_by_subject"
        ]
      },
      {
        description: "Utilize the Articles gateway at the University of Michigan Library to access scholarly journal articles, newspaper articles, book chapters, and conference proceedings. For subject-specific searches, explore our comprehensive databases.",
        slug: "articles",
        title: "Articles",
        search_options: [
          "keyword_contains",
          "exact",
          "title",
          "author",
          "subject",
          "publication_date",
          "issn",
          "isbn"
        ]
      },
      {
        description: "Explore University of Michigan Library's databases, tailored to specific subjects and formats. Access subscription databases, locally created collections, and open-access resources. Browse by alphabetical order or academic discipline to find what you need.",
        slug: "databases",
        title: "Databases",
        search_options: [
          "keyword",
          "title",
          "title_starts_with",
          "academic_discipline",
          "publisher"
        ]
      },
      {
        description: "Access University of Michigan Library's Online Journals, including scholarly journals, newspapers, trade publications, and magazines. Find subscription and open-access journals, with detailed access and date information. Browse by title or discipline.",
        slug: "onlinejournals",
        title: "Online Journals",
        search_options: [
          "keyword",
          "title",
          "title_starts_with",
          "subject",
          "lc_subject_starts_with",
          "academic_discipline",
          "call_number_starts_with",
          "isn"
        ]
      },
      {
        description: "Discover University of Michigan Library's Guides and More section for research guides, specialty sites, blogs, and online exhibits. Explore services, spaces, and collections, and visit lib.umich.edu for staff info, news, events, and physical exhibits.",
        slug: "guidesandmore",
        title: "Guides and More",
        search_options: [
          "keyword",
          "title"
        ]
      }
    ]
  end

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

  def self.for_datastore(slug)
    datastore = datastores.find { |x| x[:slug] == slug }

    OpenStruct.new(
      title: datastore[:title],
      description: datastore[:description],
      icons: Icons.new,
      styles: ["styles.css", "datastores/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js"]
      # search_options: SearchOptions.for(slug)
    )
  end

  def self.for_static_page(slug)
    page = static_pages.find { |x| x[:slug] == slug }

    OpenStruct.new(
      title: page[:title],
      description: page[:description],
      icons: Icons.new,
      styles: ["styles.css", "pages/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js"]
    )
  end

  def self.for_404_page
    OpenStruct.new(
      title: "404 - Page not found",
      description: "Page not found (404) at University of Michigan Library. Return to the homepage, search by title/keyword, browse all Databases or Online Journals, or ask a librarian for assistance in locating resources.",
      icons: Icons.new,
      styles: ["styles.css", "pages/styles.css"],
      scripts: ["scripts.js", "partials/scripts.js"]
    )
  end
end
