require_relative 'cypher_deck'

class Cypher
  attr_accessor :cypher_deck, :input, :output

  def initialize(input)
    self.cypher_deck = CypherDeck.new
    self.input = input
  end

  def encode
    output = numerize_string(input)
    keystream_values = output.map{ |v| cypher_deck.next_value }
    output = output.each_with_index.map{|value, index| value + keystream_values[index] }.map &method(:int_to_char)
    group_string(output.join).join(" ")
  end

  def decode
    output = numerize_string(input)
    keystream_values = output.map{ |v| cypher_deck.next_value }
    output = output.each_with_index.map{|value, index| (26 + value - keystream_values[index]) % 26 }.map &method(:int_to_char)
    group_string(output.join).join(" ")
  end

  def numerize_string(string)
    pad_string(string.gsub(/[^A-Za-z]/,"")).split("").map &method(:char_to_int)
  end

  def pad_string(string)
    string + "X" * ((Cypher.chunk_size - string.size % Cypher.chunk_size) % Cypher.chunk_size)
  end

  def group_string(string)
    group_count = string.size / 5
    (0..(group_count - 1)).map do |group_number|
      string.slice((0 + Cypher.chunk_size * group_number)..(Cypher.chunk_size * group_number + Cypher.chunk_size - 1))
    end
  end

  def stringify_array(numeric_array)
    numeric_array.map(&method(:int_to_char)).join
  end

  def self.encode(string)
    cypher = Cypher.new(string)
    cypher.encode
  end

  def self.decode(string)
    cypher = Cypher.new(string)
    cypher.decode
  end

  def self.chunk_size
    5
  end
end
