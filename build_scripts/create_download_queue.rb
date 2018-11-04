#!/usr/bin/env ruby

require 'fileutils'
require 'nokogiri'
require 'colorize'


SCRIPT_VERSION = "0.0.1"

PROJECT_ROOT = __FILE__.split("/")[0..-3].join("/")
BASE_URL = "https://web.archive.org"


INDEX_FILE_DIRECTORY = PROJECT_ROOT + "/recovered_content/indexes/*"
DOWNLOAD_FOLDER_PATH = PROJECT_ROOT + "/recovered_content/articles/"
DOWNLOAD_QUEUE_FILE = PROJECT_ROOT + "/tmp/queue.txt"

LINK_SELECTOR = "span.field-content>a"

# Helper functions

def set_working_dir dir
  FileUtils.cd dir
end

def create_parent_directories_of 
  FileUtils.mkdir_p(File.dirname(path))
end

def clear_queue_if_exists 
  if File.exist? DOWNLOAD_QUEUE_FILE
    puts "❗️  Found existing download queue (#{DOWNLOAD_QUEUE_FILE})".red
    puts "❗️  Deleting queue".red
    File.delete DOWNLOAD_QUEUE_FILE
    puts "✅  Done\n".green
  end
end

def enqueue_links_from_index_file index_file_path
  html = File.read index_file_path
  doc = Nokogiri::HTML(html)
  rows = doc.css(LINK_SELECTOR)

  puts "\tFound ".yellow + "#{rows.count}".magenta + " articles".yellow
  rows.each do |row|
    url = "#{BASE_URL}#{row.attr "href"}"
    enqueue_url url
  end
  puts "\tEnqueued ".green + "#{rows.count}".magenta + " articles".green
end

def enqueue_url url
  File.open DOWNLOAD_QUEUE_FILE, "a+" do |f|
    download_file_path = DOWNLOAD_FOLDER_PATH + url.split("/")[-1]
    f.puts "wget --no-clobber \"#{url}\" -O \"#{download_file_path}\""
  end
end


# Runtime

puts "\ncreate_download_queue ".green + "v#{SCRIPT_VERSION}\n".yellow
puts "🌀  Setting up...".blue

set_working_dir PROJECT_ROOT
create_parent_directories_of DOWNLOAD_QUEUE_FILE
clear_queue_if_exists

puts "🌀  Looking for index files in ".yellow + INDEX_FILE_DIRECTORY.magenta

index_files = Dir[INDEX_FILE_DIRECTORY]
puts "✅  Found ".green + "#{index_files.count}".magenta +  " index files".green

index_files.each_with_index do |file, i|
  puts "ℹ️  Processing index file ".yellow + "#{i}".green
  enqueue_links_from_index_file file
end

puts "✅  Script completed".green
puts "(Run the download script next)".green