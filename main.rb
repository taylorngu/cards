class Card

  include Comparable 

  #Class variables suits and faces
  @@suits = ['Diamonds', 'Clubs', 'Hearts', 'Spades']
  @@faces = ['Swan', 'Trey', 'Boat', 'Nickel', 'A Boot', 'Mullet', 'Snowman', 'Niner', 'Sawbuck', 'J-Bird', 'Dame', 'Cowboy', 'Rocket']

  #Class getter methods for the class variables
  def self.suits
    return @@suits
  end

  def self.faces
    return @@faces
  end

  #Constructor method with random default number that sets the cards number 0..51
  def initialize(num = rand(52))
    self.num = num
  end

  #Instance getter method for number (do not define yourself)
  attr_reader :num 

  #Instance methods for suit, face, value, name, to_s, and spaceship
  def suits
    return self.class.suits
  end

  def faces
    return self.class.faces
  end

  def face
    return self.faces[self.num % 13]
  end

  def suit
    return self.suits[self.num / 13]
  end

  def name 
    return '%s of %s' % [self.face, self.suit]
  end

  def num=(num = rand(52))
    @num = num % 52
  end 

  def value 
    return self.num % 13
  end

  def to_s
    return self.name 
  end

  def <=>(other)
    if self.value == other.value
      return self.num / 13 <=> other.num / 13
    else 
      return self.value <=> other.value 
    end
  end
end

class Shoe
  
  #Constructor method with default argument of 1 that sets the cards from however many decks are included
  def initialize(n = 1)
    self.cards = (0..n * 52 - 1).to_a.map{|num| Card.new(num)}
  end
  #Instance getter method for cards (do not define yourself)
  attr_accessor :cards

  #Instance in-place and out-of-place shuffle methods
  def shuffle!
    @cards.each_index do |i|
      j = rand(i..cards.length - 1)
      @cards[i], @cards[j] =  @cards[j], @cards[i]
    end
    return self
  end

  def shuffle 
    new = Shoe.new 
    new.cards = @cards
    new.shuffle!
    return new
  end  

  #Instance method to draw a card from the shoe
  def draw
    return @cards.pop
  end

  #Instance method to deal a hand (default of 5 cards)
  def dealHand 
    h = Hand.new
    5.times do 
      h.addCard(self.draw)
    end
    return h
  end

  #Instance method to deal a table (array) of hands (default of 4 hands of 5 cards each)
  #Deal cards one at a time
  def dealTable(hands = 4, cards = 5)
    table = []
    hands.times do 
      table << Hand.new
    end
    cards.times do
      table.each{|i| i.addCard(@cards.pop)} 
    end 
    return table
  end
end

class Hand

  include Comparable

  #Instance constructor method with no arguments
  def initialize()
    @cards = []
  end

  #Instance getter and setter methods for cards (do not define yourself)
  attr_accessor :cards

  #Instance method to add a card (default of new random card)
    #Also sorts cards
  def addCard(card = Card.new)
    @cards << card
    @cards.sort! #sorts least to greatest
    return self 
  end 
  
  #Instance methods spaceship, highCard?, onePair?, twoPair?, threeOfAKind?, straight?, flush?, fullHouse?, fourOfAKind?, straightFlush?, and type
    #Spaceship should compare the high card if hands are of the same type
    #Type should just return a string

  def straightFlush?
    return true if self.suitCount.length == 1 &&  self.consec?
    return false
  end

  def fourOfAKind?
    return true if self.faceCount.any?{|k, v| v >= 4 }
    return false 
  end 

  def fullHouse?
    if self.threeOfAKind?
      dup = self.faceCount.delete_if{|k, v| v >= 3 }
      return true if dup.any?{|k, v| v >= 2 }
    end 
  end 

  def flush?
    return true if self.suitCount.length == 1 
    return false
  end

  def straight?
    return true if self.cards.map{|e| e.value}.each_cons(2).all? {|a, b| b == a + 1 }
    return false
  end

  def threeOfAKind?
    return true if self.faceCount.any?{|k, v| v >= 3 }
    return false
  end

  def twoPair?
    if self.onePair?
      return true if self.faceCount.select{|k, v| v >= 2}.length == 2
    end 
  end

  def onePair?
    return true if self.faceCount.any?{|k, v| v >= 2 }
    return false
  end

  def highCard?
    return true if self.onePair? == false && self.straight? == false &&self.flush? == false 
  end

  def <=>(other)
    if self.rank == other.rank
      return self.cards.pop <=> other.cards.pop
    end
    return self.rank <=> other.rank
  end

  # Extra methods 
  def rank 
    rankList = ["High Card", "One Pair", "Two Pair", "Three of a Kind", "Straight", "Flush", "Full House", "Four of a Kind", "Straight Flush"]
    return rankList.index(self.type)
  end

  def type  
    return "Straight Flush" if self.straightFlush?
    return "Four of a Kind" if self.fourOfAKind? 
    return "Full House" if self.fullHouse?  
    return "Flush" if self.flush?  
    return "Straight" if self.straight?  
    return "Three of a Kind" if self.threeOfAKind?  
    return "Two Pair" if self.twoPair?  
    return "One Pair" if self.onePair?
    return "High Card" 
  end 

  def faceCount
    count = @cards.map{|e| e.face}.inject(Hash.new(0)){|h,v|h[v] += 1; h }
    return count
  end

  def suitCount 
    count = @cards.map{|e| e.suit}.inject(Hash.new(0)){|h,v|h[v] += 1; h }
    return count
  end 

  def consec?
    return @cards.each_cons(2).all? {|a, b| b.num == a.num + 1 }
  end
end

#Testing Shoe
puts("Testing Shoe & Hand Functions:")
print("\n\n")
puts("Making Shoe: h = Shoe.new")
h = Shoe.new
puts(h)
print("\n")

puts("Shuffle Shoe: h.shuffle & h.shuffle!")
puts("h == h.shuffle: #{h == h.shuffle}")
puts(h.shuffle)
puts("h == h.shuffle!: #{h == h.shuffle!}")
puts(h.shuffle!)
print("\n")

puts("Making Hands: k = Hand.new")
k = Hand.new
puts(k)
print("\n")

puts("Deals Cards to Hand: k = h.dealHand")
k = h.dealHand
print("\n")
puts(k.cards)
print("\n")

puts("Deals Cards to Table: h.deal")
print("\n")
o = Shoe.new
n = o.dealTable
puts("Hand 1: #{n[0].cards}")
puts("Hand 2: #{n[1].cards}")
puts("Hand 3: #{n[2].cards}")
puts("Hand 4: #{n[3].cards}")
print("\n")

puts("Drawing Cards: h.draw")
i = h.draw
puts(i)
print("\n")

puts("Adding Card to Hand From Shoe: k.addCard(h.draw)")
print("\n")
k.addCard(i)
puts(k.cards)
print("\n")

puts("Type of Hand: k.type")
puts(k.type)

print("\n\n")
puts("Testing Types of Hands:")
print("\n\n")

h = Shoe.new
strFlush = Hand.new.addCard(h.draw).addCard(h.draw).addCard(h.draw).addCard(h.draw).addCard(h.draw)
puts("Straight Flush: #{strFlush.straightFlush?}")
puts(strFlush.cards.map{|e| e.name})

print("\n")
h = Shoe.new
fourKind = Hand.new.addCard(h.cards[0]).addCard(h.cards[13]).addCard(h.cards[26]).addCard(h.cards[39]).addCard(h.cards[1])
puts("Four of a Kind: #{fourKind.fourOfAKind?}")
puts(fourKind.cards.map{|e| e.name})

print("\n")
h = Shoe.new
fullHo = Hand.new.addCard(h.cards[0]).addCard(h.cards[13]).addCard(h.cards[26]).addCard(h.cards[14]).addCard(h.cards[1])
puts("Full House: #{fullHo.fullHouse?}")
puts(fullHo.cards.map{|e| e.name})

print("\n")
h = Shoe.new
flu = Hand.new.addCard(h.cards[0]).addCard(h.cards[2]).addCard(h.cards[4]).addCard(h.cards[8]).addCard(h.cards[10])
puts("Flush: #{flu.flush?}")
puts(flu.cards.map{|e| e.name})

print("\n")
h = Shoe.new
stra = Hand.new.addCard(h.cards[0]).addCard(h.cards[14]).addCard(h.cards[28]).addCard(h.cards[42]).addCard(h.cards[17])
puts("Straight: #{stra.straight?}")
puts(stra.cards.map{|e| e.name})

print("\n")
h = Shoe.new
threeKind = Hand.new.addCard(h.cards[0]).addCard(h.cards[13]).addCard(h.cards[26]).addCard(h.cards[21]).addCard(h.cards[1])
puts("Three of a Kind: #{threeKind.threeOfAKind?}")
puts(threeKind.cards.map{|e| e.name})

print("\n")
h = Shoe.new
twoPa = Hand.new.addCard(h.cards[0]).addCard(h.cards[13]).addCard(h.cards[1]).addCard(h.cards[14]).addCard(h.cards[8])
puts("Two Pair: #{twoPa.twoPair?}")
puts(twoPa.cards.map{|e| e.name})

print("\n")
h = Shoe.new
onePa = Hand.new.addCard(h.cards[0]).addCard(h.cards[13]).addCard(h.cards[27]).addCard(h.cards[51]).addCard(h.cards[8])
puts("One Pair: #{onePa.onePair?}")
puts(onePa.cards.map{|e| e.name})

print("\n")
h = Shoe.new
highC = Hand.new.addCard(h.cards[0]).addCard(h.cards[49]).addCard(h.cards[28]).addCard(h.cards[5]).addCard(h.cards[8])
puts("High Card: #{highC.highCard?}")
puts(highC.cards.map{|e| e.name})

print("\n\n")
puts("Testing Comparing Hands:")
print("\n\n")

puts("Case: Straight Flush > Four of a Kind: #{(strFlush > fourKind) == true}")
puts("Case: Four of a Kind > Full House: #{(fourKind > fullHo) == true}")
puts("Case: Full House > Flush: #{(fullHo > flu) == true}")
puts("Case: Flush > Straight: #{(flu > stra) == true}")
puts("Case: Straight > Three of a Kind: #{(stra > threeKind) == true}")
puts("Case: Three of a Kind > Two Pair: #{(threeKind > twoPa) == true}")
puts("Case: Two Pair > One Pair: #{(twoPa > onePa) == true}")
puts("Case: One Pair > High Card: #{(onePa > highC) == true}")

h = Shoe.new
highC = Hand.new.addCard(h.cards[0]).addCard(h.cards[49]).addCard(h.cards[28]).addCard(h.cards[5]).addCard(h.cards[8])
h = Shoe.new
highC2 = Hand.new.addCard(h.cards[1]).addCard(h.cards[37]).addCard(h.cards[22]).addCard(h.cards[8]).addCard(h.cards[23])

puts("Case: High Card 1 <=> High Card 2: #{highC <=> highC2}")

print("\n")
puts("High Card 1:")
puts(highC.cards.map{|e| e.name})
print("\n")
puts("High Card 2:")
puts(highC2.cards.map{|e| e.name})
