require 'minitest/autorun'
require 'set'
require_relative 'person.rb'
require_relative 'santa_finder.rb'

class TestSantaFinder < MiniTest::Unit::TestCase
  def test_one_person_list
    assert_equal SantaFinder.match([Person.new("A B C")]), {}
  end

  def test_two_person_list
    a = Person.new("A A A")
    b = Person.new("B B B")
    assert_equal SantaFinder.match([a,b]), {a => b, b => a}
  end

  def test_unsolvable_list
    a = Person.new("A A A")
    b = Person.new("B B B")
    c = Person.new("C B C")
    assert_equal SantaFinder.match([a,b,c]), {}
  end

  def test_different_random_seeds
    array = [
              Person.new("Luke Skywalker   <luke@theforce.net>"),
              Person.new("Leia Skywalker   <leia@therebellion.org>"),
              Person.new("Toula Portokalos <toula@manhunter.org>"),
              Person.new("Gus Portokalos   <gus@weareallfruit.net>"),
              Person.new("Bruce Wayne      <bruce@imbatman.com>"),
              Person.new("Virgil Brigman   <virgil@rigworkersunion.org>"),
              Person.new("Lindsey Brigman  <lindsey@iseealiens.net>")
            ]
    1.upto(100) do |i|
      solution = SantaFinder.match(array, Random.new(i))
      assert validate_solution(array, solution)
    end
  end

  def validate_solution(list, solution)
    valid = true
    valid = false if list.length != solution.length
    valid = false if list.to_set != solution.keys.to_set
    valid = false if list.to_set != solution.values.to_set
    solution.each do |person, santa|
      valid = false if(person == santa || person.family?(santa))
    end
    return valid
  end
end

