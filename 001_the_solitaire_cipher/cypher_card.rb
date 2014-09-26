def char_to_int(char)
  char.ord - 64
end

def int_to_char(integer)
  (((integer - 1) % 26) + 65).chr
end

class CypherCard
  attr_accessor :tag, :value

  def initialize(value, joker_tag=nil)
    self.value = value
    self.tag = joker_tag
  end

  def joker?
    !!tag
  end

  def letter
    return nil if joker?
    char_to_int(value)
  end
end
