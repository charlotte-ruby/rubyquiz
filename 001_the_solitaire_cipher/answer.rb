require 'optparse'
require_relative 'cypher'
require 'pry'
# Script

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: answer.rb [options] input"

  opts.on("-d", "--decode", "Decode input") do |v|
    options[:decode] = true
  end
end.parse!

if options[:decode]
  puts Cypher.decode(ARGV[0])
else
  puts Cypher.encode(ARGV[0])
end
