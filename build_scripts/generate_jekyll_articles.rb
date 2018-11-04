#!/usr/bin/env ruby

require 'fileutils'
require 'colorize'

require_relative 'helper_classes/article_parser'
require_relative 'helper_classes/jekyll_article_generator'

# Constants

SCRIPT_VERSION = "0.0.1"


HTML_ARTICLE_DIRECTORY = "recovered_content/articles"
IGNORE_LIST_FILE_PATH = "data/article_ignore_list.txt"

MARKDOWN_FILE_OUTPUT_DIRECTORY = "_posts"

# Helpers

def create_parent_directories_of dir
  FileUtils.mkdir_p(dir)
end

# Runtime

puts "\ngenerate_jekyll_articles ".green + "v#{SCRIPT_VERSION}\n".yellow

create_parent_directories_of MARKDOWN_FILE_OUTPUT_DIRECTORY

html_files = Dir[HTML_ARTICLE_DIRECTORY + "/*"]
puts "ℹ️  Found ".yellow + "#{html_files.count}".magenta + " HTML articles".yellow


ignore_file_count = File.
  read(IGNORE_LIST_FILE_PATH).
  split("\n").
  map {|file_name| "#{HTML_ARTICLE_DIRECTORY}/#{file_name}"}.
  each {|file_path| html_files.delete file_path}.
  count

puts "ℹ️  Ignoring ".yellow + "#{ignore_file_count}".red + " exclude files".yellow

selected_files = html_files

start_t = Time.now

selected_files.each_with_index do |html_file_path, i|
  puts "🌀 Generating Jekyll article [".blue + "#{i + 1}".green + "/#{selected_files.count}]".blue
  begin
    html = File.read html_file_path
    article = ArticleParser.parse html
    jekyll_article = JekyllArticleGenerator.generate article
    output_file = "#{MARKDOWN_FILE_OUTPUT_DIRECTORY}/#{article['pgg_id']}.md"
    File.open output_file, 'w' do |f|
      f.write jekyll_article
    end
    puts "✅  Done".green
  rescue Exception => ex
    puts "❌  Conversion failed.".red
    puts ex
  end
end

end_t = Time.now

puts "✅  Converted ".green + "#{selected_files.count}".yellow + " files".green
puts "⏱ #{end_t - start_t}s".green