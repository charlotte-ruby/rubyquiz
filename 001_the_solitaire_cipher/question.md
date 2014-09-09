# The Solitaire Cipher (#1)

Cryptologist Bruce Schneier designed the hand cipher "Solitaire" for Neal Stephenson's book "Cryptonomicon". Created to be the first truly secure hand cipher, Solitaire requires only a deck of cards for the encryption and decryption of messages.

While it's true that Solitaire is easily completed by hand given ample time, using a computer is much quicker and easier. Because of that, Solitaire conversion routines are available in many languages, though I've not yet run across one in Ruby.

This week's quiz is to write a Ruby script that does the encryption and decryption of messages using the Solitaire cipher.

Let's look at the steps of encrypting a message with Solitaire.

1. Discard any non A to Z characters, and uppercase all remaining letters. Split the message into five character groups, using Xs to pad the last group, if needed. If we begin with the message "Code in Ruby, live longer!", for example, we would now have:

CODEI NRUBY LIVEL ONGER

2. Use Solitaire to generate a keystream letter for each letter in the message. This step is detailed below, but for the sake of example let's just say we get:

DWJXH YRFDG TMSHP UURXJ

3. Convert the message from step 1 into numbers, A = 1, B = 2, etc:

3 15 4 5 9  14 18 21 2 25  12 9 22 5 12  15 14 7 5 18

4. Convert the keystream letters from step 2 using the same method:

4 23 10 24 8  25 18 6 4 7  20 13 19 8 16  21 21 18 24 10

5. Add the message numbers from step 3 to the keystream numbers from step 4 and subtract 26 from the result if it is greater than 26. For example, 6 + 10 = 16 as expected, but 26 + 1 = 1 (27 - 26):

7 12 14 3 17  13 10 1 6 6  6 22 15 13 2  10 9 25 3 2

6. Convert the numbers from step 5 back to letters:

GLNCQ MJAFF FVOMB JIYCB

That took a while to break down, but it's really a very simple process. Decrypting with Solitaire is even easier, so let's look at those steps now. We'll work backwards with our example now, decrypting "GLNCQ MJAFF FVOMB JIYCB".

1. Use Solitaire to generate a keystream letter for each letter in the message to be decoded. Again, I detail this process below, but sender and receiver use the same key and will get the same letters:

DWJXH YRFDG TMSHP UURXJ

2. Convert the message to be decoded to numbers:

7 12 14 3 17  13 10 1 6 6  6 22 15 13 2  10 9 25 3 2

3. Convert the keystream letters from step 1 to numbers:

4 23 10 24 8  25 18 6 4 7  20 13 19 8 16  21 21 18 24 10

4. Subtract the keystream numbers from step 3 from the message numbers from step 2. If the message number is less than or equal to the keystream number, add 26 to the message number before subtracting. For example, 22 - 1 = 21 as expected, but 1 - 22 = 5 (27 - 22):

3 15 4 5 9  14 18 21 2 25  12 9 22 5 12  15 14 7 5 18

5. Convert the numbers from step 4 back to letters:

CODEI NRUBY LIVEL ONGER

Transforming messages is that simple. Finally, let's look at the missing piece of the puzzle, generating the keystream letters.

First, let's talk a little about the deck of cards. Solitaire needs a full deck of 52 cards and the two jokers. The jokers need to be visually distinct and I'll refer to them below as A and B. Some steps involve assigning a value to the cards. In those cases, use the cards face value as a base, Ace = 1, 2 = 2... 10 = 10, Jack = 11, Queen = 12, King = 13. Then modify the base by the bridge ordering of suits, Clubs is simply the base value, Diamonds is base value + 13, Hearts is base value + 26, and Spades is base value + 39. Either joker values at 53. When the cards must represent a letter Clubs and Diamonds values are taken to be the number of the letter (1 to 26), as are Hearts and Spades after subtracting 26 from their value (27 to 52 drops to 1 to 26). Now let's make sense of all that by putting it to use.

1. Key the deck. This is the critical step in the actual operation of the cipher and the heart of it's security. There are many methods to go about this, such as shuffling a deck and then arranging the receiving deck in the same order or tracking a bridge column in the paper and using that to order the cards. Because we want to be able to test our answers though, we'll use an unkeyed deck, cards in order of value. That is, from top to bottom, we'll always start with the deck:

Ace of Clubs
...to...
King of Clubs
Ace of Diamonds
...to...
King of Diamonds
Ace of Hearts
...to...
King of Hearts
Ace of Spades
...to...
King of Spades
"A" Joker
"B" Joker

2. Move the A joker down one card. If the joker is at the bottom of the deck, move it to just below the first card. (Consider the deck to be circular.) The first time we do this, the deck will go from:

1 2 3 ... 52 A B

To:

1 2 3 ... 52 B A

3. Move the B joker down two cards. If the joker is the bottom card, move it just below the second card. If the joker is the just above the bottom card, move it below the top card. (Again, consider the deck to be circular.) This changes our example deck to:

1 B 2 3 4 ... 52 A

4. Perform a triple cut around the two jokers. All cards above the top joker move to below the bottom joker and vice versa. The jokers and the cards between them do not move. This gives us:

B 2 3 4 ... 52 A 1

5. Perform a count cut using the value of the bottom card. Cut the bottom card's value in cards off the top of the deck and reinsert them just above the bottom card. This changes our deck to:

2 3 4 ... 52 A B 1  (the 1 tells us to move just the B)

6. Find the output letter. Convert the top card to it's value and count down that many cards from the top of the deck, with the top card itself being card number one. Look at the card immediately after your count and convert it to a letter. This is the next letter in the keystream. If the output card is a joker, no letter is generated this sequence. This step does not alter the deck. For our example, the output letter is:

D  (the 2 tells us to count down to the 4, which is a D)

7. Return to step 2, if more letters are needed.

For the sake of testing, the first ten output letters for an unkeyed deck are:

D (4)  W (49)  J (10)  Skip Joker (53)  X (24)  H (8)
Y (51)  R (44)  F (6)  D (4)  G (33)

That's all there is to Solitaire, finally. It's really longer to explain than it is to code up.

Solutions to this quiz should accept a message as a command line argument and encrypt or decrypt is as needed. It should be easy to tell which is needed by the pattern of the message, but you can use a switch if you prefer.

All the examples for this quiz assume an unkeyed deck, but your script can provide a way to key the deck, if desired. (A real script would require this, of course.)

Here's a couple of messages to test your work with. You'll know when you have them right:

CLEPK HHNIY CFPWH FDFEH

ABVAW LWZSY OORYK DUPVH

Quiz Summary

YOURC IPHER ISWOR KINGX

WELCO METOR UBYQU IZXXX

That's what you should have seen, if you ran a working Solitaire cipher decryption script over the last two lines of the quiz. All the submitted solutions did just that in my tests, though some needed a tiny tweak here or there.

I think the steps of the algorithm are much easier than I made them sound in the quiz. In fact, I was wondering if anyone would just combine encryption and decryption, as they are nearly the same process. And look, someone did:

ruby
    class Encrypter
      def initialize(keystream)
        @keystream = keystream
      end

      def sanitize(s)
        s = s.upcase
        s = s.gsub(/[^A-Z]/, "")
        s = s + "X" * ((5 - s.size % 5) % 5)
        out = ""
        (s.size / 5).times {|i| out << s[i*5,5] << " "}
        return out
      end

      def mod(c)
        return c - 26 if c > 26
        return c + 26 if c < 1
        return c
      end

      def process(s, &combiner)
        s = sanitize(s)
        out = ""
        s.each_byte { |c|
          if c >= ?A and c <= ?Z
            key = @keystream.get
            res = combiner.call(c, key[0])
            out << res.chr
          else
            out << c.chr
          end
        }
        return out
      end

      def encrypt(s)
        return process(s) {|c, key| 64 + mod(c + key - 128)}
      end

      def decrypt(s)
        return process(s) {|c, key| 64 + mod(c -key)}
      end
    end

That's a pretty straight forward class to handle both operations by Niklas Frykholm. The heart of this operation is the process() method. It guides the conversion for both encryption and decryption. It starts by handing off the message to the sanitize() method for the stripping of non-letter characters, uppercasing, and being broken into proper chunks. Note that if we're decrypting, this call should have no noticeable effects (though it does waste a little processing time).

Once the message has been placed into the proper format, process() continues walking the now almost identical steps to transform the message either way. In the one other place the steps diverge, the addition or subtraction of the keystream letters, Niklas uses a passed in block to do the right thing. The block comes from the methods encrypt() and decrypt(), which are just an interface to the clever processing routine.

I didn't mention this in the quiz itself, but the above process of encryption and decryption is actually fundamental to many ciphers, not just Solitaire. With a different method of keystream generation, the above class could instead be used for DES encryption or other methods. Niklas supports this well, by having the keystream object passed into the constructor.

The other half of Solitaire is keystream generation, of course. Many people used a Deck class (and some a Card class) to drive this process. Here's one such class by Thomas Leitner:

ruby
    # Handles the deck
    class Deck

      # Initializes the deck with the default values
      def initialize
        @deck = (1..52).to_a << 'A' << 'B'
      end

      # Operation "move a" (step 2)
      def move_A
        move_down( @deck.index( 'A' ) )
      end

      # Operation "move b" (step 3)
      def move_B
        2.times { move_down( @deck.index( 'B' ) ) }
      end

      # Operation "triple cut" (step 4)
      def triple_cut
        a = @deck.index( 'A' )
        b = @deck.index( 'B' )
        a, b = b, a if a > b
        @deck.replace( [ @deck[(b + 1)..-1],
                         @deck[a..b],
                         @deck[0...a] ].flatten )
      end

      # Operation "count cut" (step 5)
      def count_cut
        temp = @deck[0..(@deck[-1] - 1)]
        @deck[0..(@deck[-1] - 1)] = []
        @deck[-1..-1] = [temp, @deck[-1]].flatten
      end

      # Operation "output the found letter" (step 6)
      def output_letter
        a = @deck.first
        a = 53 if a.instance_of? String
        output = @deck[a]
        if output.instance_of? String
          nil
        else
          output -= 26 if output > 26
          (output + 64).chr
        end
      end

      # Shuffle the deck using the initialization number +init+
      # and the method +method+.
      # Currently there are only two methods: <tt>:fisher_yates</tt>
      # and <tt>naive</tt>.
      def shuffle( init, method = :fisher_yates )
        srand( init )
        self.send( method.id2name + "_shuffle", @deck )
      end

      private

      # From pleac.sf.net
      def fisher_yates_shuffle( a )
        (a.size-1).downto(0) { |i|
          j = rand(i+1)
          a[i], a[j] = a[j], a[i] if i != j
        }
      end

      # From pleac.sf.net
      def naive_shuffle( a )
        for i in 0...a.size
          j = rand(a.size)
          a[i], a[j] = a[j], a[i]
        end
      end

      # Moves the index one place down while treating the used array
      # as circular list.
      def move_down( index )
        if index == @deck.length - 1
          @deck[1..1] = @deck[index], @deck[1]
          @deck.pop
        else
          @deck[index], @deck[index + 1] = @deck[index + 1], @deck[index]
        end
      end

    end

Notice that Thomas doesn't retain much notion of "cards" per say, but instead just treats them as the numbers they represent. Most of the methods in this class are just steps from keystream generation: move_A() and move_B() which are just an interface for the private move_down(), triple_cut(), and count_cut(). Turning those into the actual process needed is trivial:

ruby
    # Generates a keystream for the given +length+.
    def generate_keystream( length )
      deck = @deck.dup
      result = []
      while result.length != length
        deck.move_A
        deck.move_B
        deck.triple_cut
        deck.count_cut
        letter = deck.output_letter
        result << letter unless letter.nil?
      end
      result.join
    end

That's all there was to solving the quiz, but that's certainly not all their was to the submissions. I'll see if I can point out a few highlights you might want to take a look at, if you haven't already.

Several people provided alternate ways to key the deck, similar to Thomas' shuffle() method above. They real trick to keying the deck for the cipher is that two decks will need to be keyed identically for it to work. Given that, I believe Moses Hohman has a very nice solution, reading in a deck.yaml file format as the key. Moses also makes thorough use of unit testing in his solution, which was a real eye opener for people like me who haven't taken the time to learn Ruby's modules for this process.

The solution by Florian Gross is a tricky code module, you probably saw me trying decipher out loud on Ruby Talk. I think it's a really good example of how to make a module that doubles as an application, once you get your head around it. The main trick involved is mixing the module into itself, to duplicate its interface in its own class methods. Those class methods provide the stand-alone application interface, while the module can still be mixed into future projects. Because of this, and the fact that Florian uses a Card class, I bet his solution adapts well to solving other hand ciphers, many of which use a deck of cards.

Finally, Jamis Buck submitted a solution that makes use of his Copland Inversion of Control framework for Ruby. I don't want to say too much about this, lest my ignorance show through, but this seems to be a handy abstraction for handling code dependancies, among other things. I have it installed now and am reading the manual, so I hope to understand even more about how it works soon. I can already say though that I think it's worth a look, especially if you're familiar with IoC or even Aspect Oriented Programming (feels similar to me).

Really all the solutions had interesting elements to them. I think I saw something clever in every last one of them, even the ones I didn't single out. For example, many of you convinced me I need to kick 'getoptlong' to the curb and look into 'optparse' immediately. The Pickaxe II just can't get here soon enough. My advice: Browse through the submitted solutions when you have some time and learn some handy tricks of the Ruby trade.

One last thing I wanted to mention, from the quiz discussion. Dominik Werder asked:

So do I understand that right, Bruce Schneier claims that Solitaire is a
real cryptographic secure pseudo random number generator?
Cool, a PRNG for the small budget :)

I was hoping this would spark some interesting discussion, but either no one had any thoughts on this, or everyone just Googled for the answer.

Bruce Schneier set out to design Solitaire to be the first truly secure hand cipher. However, Paul Crowley has found a bias in the random number generation used by the cipher. In other words, it's not as strong as originally intended and being a hand cipher it does not compete with the more powerful forms of digital encryption, naturally.

If you're interested in this or other Solitaire issues, I refer you to the author's site:

The Official Solitaire Site

My thanks to those who played and those who just watched. New quiz tomorrow and I think it's a fun problem, so don't forget to check your e-mail even if you're at RubyConf...
