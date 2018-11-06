module Jekyll
  module UrlSafe
    safe true
    priority :low

    def url_safe input
      #URI.escape(input, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      input.upcase
    end
  end
end

Liquid::Template.register_filter(Jekyll::UrlSafe)
puts "\n\n\nRegistered!!!"