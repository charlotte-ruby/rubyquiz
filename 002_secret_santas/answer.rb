require_relative "person.rb"
require_relative "santa_finder.rb"

SantaFinder.match(
  [
    Person.new("Luke Skywalker   <luke@theforce.net>"),
    Person.new("Leia Skywalker   <leia@therebellion.org>"),
    Person.new("Toula Portokalos <toula@manhunter.org>"),
    Person.new("Gus Portokalos   <gus@weareallfruit.net>"),
    Person.new("Bruce Wayne      <bruce@imbatman.com>"),
    Person.new("Virgil Brigman   <virgil@rigworkersunion.org>"),
    Person.new("Lindsey Brigman  <lindsey@iseealiens.net>")
  ])
