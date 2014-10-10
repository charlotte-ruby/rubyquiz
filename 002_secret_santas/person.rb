class Person
  attr_reader :first, :last, :email

  def initialize input
    @first, @last, @email =input.split
  end

  def family?(other_person)
    @last == other_person.last
  end

  def to_s
    "#{@first} #{@last}"
  end
end
