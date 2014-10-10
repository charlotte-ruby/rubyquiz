require_relative 'person.rb'

class SantaFinder
  def self.match the_list, rand = Random.new
    SantaFinder.new(the_list, rand).call
  end

  def call
    solution = recursively_match_santas(Hash.new, @people)
    if solution.empty?
      puts "No valid solutions found"
    else
      solution.each do |person, santa|
        puts "#{santa} will give to #{person}"
      end
    end
    solution
  end


  private
  def initialize people, rand
    @people = people.shuffle(:random => rand)
  end

  def recursively_match_santas matches, people_left
    index = @people.length - people_left.length
    if people_left.length == 0
      return matches
    else
      current_person = @people[index]
      people_left.each do |person|
        if current_person != person && !current_person.family?(person)
          candidate = recursively_match_santas(matches.merge({current_person => person}),
                                                people_left - [person])
          unless candidate.empty?
            return candidate
          end
        end
      end

      Hash.new
    end
  end
end
