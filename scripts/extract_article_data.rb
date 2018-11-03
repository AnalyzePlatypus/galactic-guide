#!/usr/bin/env ruby

require 'colorize'
require 'awesome_print'
require 'json'
require 'nokogiri'

USEFUL_EMOJI = "✅ 🌀❗️❓ 📡 💾 ℹ️"

FILE_PATH = "recovered_content/articles/1R1.html"

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
    selector: ".hideme>div:nth-of-type(7)",
    title: "alternative_index_1"
  },
  {
    selector: ".hideme>div:nth-of-type(8)",
    title: "alternative_index_2"
  },  
  {
    selector: "#author",
    title: "author"
  },
  {
    selector: "#date",
    title: "article_date"
  },
  {
   selector: ".c5:nth-of-type(2)",
   title: "ARTICLE_BODY_SELETOR"
  },
]

html = File.read FILE_PATH
doc = Nokogiri::HTML(html)

article = {}

SELECTORS.each do |field|
  value = doc.css(field[:selector]).text
  article[field[:title]] = value
end

ap article

