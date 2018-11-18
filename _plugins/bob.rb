
require 'pp'

module Jekyll
  module PGG
    # safe true
    # priority :low

    # def fetch_article_for_id id
    #   @context.registers[:site].collections["articles"].docs.select {|doc| doc["pgg_id"] == pgg_id}
    # end

    def pgg_id_to_title pgg_id
      puts pgg_id
      articles = @context.registers[:site].collections["articles"].docs.select {|d| d.data["pgg_id"] == pgg_id}
      title = articles[0].data["title"] if articles.any?
      puts title
      title
    end
  end
end

Liquid::Template.register_filter(Jekyll::PGG)
puts "\n\n\nRegistered!!!"