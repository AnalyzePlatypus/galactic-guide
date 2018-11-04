#!/usr/bin/env ruby

require 'nokogiri'

require_relative 'article_sanitizer.rb'

SELECTORS = [
  {
    selector: "div.inner > div.meta > span",
    title: "submission_string"
  },
  {
    selector: "#content-inner-inner > h1",
    title: "title"
  },
  {
    selector: "#subtitle",
    title: "subtitle"
  },
  {
    selector: "#factuality",
    title: "factuality"
  },
  {
    selector: "#pggnumber",
    title: "pgg_id"
  },
  {
    selector: "#pggdate",
    title: "pgg_date"
  },
  {
    selector: ".hideme>div:nth-of-type(7)#pggindex",
    title: "alternative_index_1"
  },
  {
    selector: ".hideme>div:nth-of-type(8)#pggindex",
    title: "alternative_index_2"
  },
  {
    selector: ".hideme>div:nth-of-type(9)#pggindex",
    title: "alternative_index_3"
  },
  {
    selector: ".hideme>div:nth-of-type(10)#pggindex",
    title: "alternative_index_4"
  },  
  {
    selector: "#author",
    title: "author"
  },
  {
    selector: "#date",
    title: "article_date"
  }
]


class ArticleParser
  def self.parse html
    @doc = Nokogiri::HTML(html)

    article = parse_selectors
    article["article_body"] = parse_body
    article["footnotes"] = parse_footnotes
    article["see_also"] = parse_see_also

    article
  end

  private

  def self.parse_selectors
    article = {}
    SELECTORS.each do |field|
      value = @doc.css(field[:selector]).text
      article[field[:title]] = value
    end
    article
  end

  def self.parse_body 
    body_selector =  ".c5:nth-of-type(2)"
    article_doc = @doc.css(body_selector)
    ArticleSanitizer.sanitize(article_doc).to_html
  end

  def self.parse_footnotes
    footnote_table = @doc.css ".c5>table"
    return [] if footnote_table.nil?
    rows =  @doc.css ".c5>table tr"
    footnotes = {}
    rows.each do |row|
      number = row.css("td:first-of-type>a").text
      content = row.css("td:nth-of-type(2)").text
      footnotes[number] = content
    end
    footnotes
  end
  
  def self.parse_see_also
    see_also_container = @doc.css ".c5>ul"
    return [] if see_also_container.nil?
    items = @doc.css ".c5>ul #pggxref"
    items.map do |suggested_link|
      suggested_link.text.split("/")[-1].gsub(".html", "")
    end
  end
end
