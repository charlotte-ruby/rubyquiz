require_relative 'cypher_card'

class CypherDeck
  attr_accessor :cards, :first_joker, :second_joker

  def initialize
    self.cards = (1..52).map do |value|
      CypherCard.new(value)
    end

    self.first_joker = CypherCard.new(53, :first)
    self.second_joker =  CypherCard.new(53, :second)

    cards << first_joker
    cards << second_joker
  end

  def move_joker(tag)
    index = cards.find_index{|card| card.tag == tag}
    if index == cards.size - 1
      cards.insert(1, cards.slice!(index))
    else
      cards[index], cards[index + 1] = cards[index + 1], cards[index]
    end
  end

  def cycle_jokers
    move_joker(first_joker.tag)
    2.times { move_joker(second_joker.tag) }
  end

  def triple_cut
    cards_above_top_joker = cards.slice!(0, top_joker_index)
    cards_below_bottom_joker = cards.slice!((bottom_joker_index + 1)..-1)

    cards.unshift(*cards_below_bottom_joker)
    cards.push(*cards_above_top_joker)
  end

  def count_cut
    moving_cards = cards.slice!(0, (cards.last.value))
    cards.insert(cards.size - 1, *moving_cards)
  end

  def top_joker_index
    joker_indexes.first
  end

  def bottom_joker_index
    joker_indexes.last
  end

  def joker_indexes
    cards.each_with_index.select{ |card, index| card.joker? }.map{|card, index| index}
  end

  def next_value
    begin
      cycle_jokers
      triple_cut
      count_cut
      value = cards.slice(cards.first.value).value
    end until value != 53

    value
  end
end
