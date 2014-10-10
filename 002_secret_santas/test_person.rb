require 'minitest/autorun'
require_relative 'person.rb'

class TestPerson < MiniTest::Unit::TestCase
  def test_initialize
    person = Person.new("Luke Skywalker   <luke@theforce.net>")
    assert_equal person.first, "Luke"
    assert_equal person.last, "Skywalker"
    assert_equal person.email, "<luke@theforce.net>"
  end

  def test_family?
    person = Person.new("Luke Skywalker   <luke@theforce.net>")
    relative = Person.new("Bill Skywalker   <bill@theforce.net>")
    non_relative = Person.new("Luke Johnson   <luke@example.net>")

    assert_equal person.family?(relative), true
    assert_equal person.family?(non_relative), false
  end
end

