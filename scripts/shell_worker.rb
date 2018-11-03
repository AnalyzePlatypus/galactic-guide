#! /usr/bin/env ruby

require 'colorize'
require_relative 'filequeue.rb'

QUEUE_FILE = 'tmp/queue.txt'

ONE_SECOND = 1
QUEUE_CHECK_INTERVAL = ONE_SECOND

def clear_console
  print " " * 40 + "\r"
end

def puts_o str
  clear_console
  print str + "\r"
end

class ShellWorker
  def initialize file
    @queue = FileQueue.new file
  end

  def run
      puts "ℹ️  Shell worker launched at".yellow + " #{Time.now}".green
      puts "ℹ️  Bound to file-based queue at ".yellow + "#{@queue.file_name}".green
      puts "ℹ️  Checking queue every".yellow  + " #{QUEUE_CHECK_INTERVAL}s".green
      loop {
        clear_console
        puts_o "🌀  Checking for items...".blue
        item = @queue.pop
        unless item.nil? 
          puts "✅  Popped new item: #{item}"
          puts `#{item}`
        end
        puts_o "💤  Sleeping".blue
        sleep QUEUE_CHECK_INTERVAL
      }
  end
end

worker = ShellWorker.new QUEUE_FILE
worker.run
