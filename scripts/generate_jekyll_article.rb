#!/usr/bin/env ruby

require 'awesome_print'

require_relative 'helper_classes/article_parser'
require_relative 'helper_classes/jekyll_article_generator'

FILE_PATH = "recovered_content/articles/9R33.html"
html = File.read FILE_PATH
article =  ArticleParser.parse html
markdown = JekyllArticleGenerator.generate article

File.open 'test.md', 'w' do |f|
  f.puts markdown
end
