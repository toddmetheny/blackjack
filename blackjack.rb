# class Splits < Blackjack
#   def initialize(card1, card2)
#     @card1 = card1
#     @card2 = card2
#     @hand1 = [@card1]
#     @hand2 = [@card2]
#   end

#   def play_first_hand
#     @second_card = deal_card()
#     @hand1 << @second_card
#   end

#   def play_second_hand
#     @
#   end
# end

class Blackjack
  attr_accessor :deck, :player_hand
  
  @@bankroll = 0

  def initialize
    suit = (1..13).to_a
    @deck = suit * 4
    @player_hand = []
    @dealer_hand = []
    @busted = false
    @dealer_busted = false
    puts "FYI: cards will be reshuffled after every hand."
  end

  def bankroll
    @@bankroll
  end

  def start
    puts "Do you want to play for fun or do you want to gamble? (Enter: 'fun' or 'gamble')"
    just_gamble = gets.chomp.downcase
    if just_gamble == "fun"
      @gambler = false
      start_game
    elsif just_gamble == "gamble"
      @gambler = true
      wager
    else
      puts "you didn't enter fun or gamble"
      start
    end
  end

  def wager
    puts "How much would you like to wager?"
    puts "Please enter a dollar amount between 1 and 100"
    @amount = gets.chomp.to_i
    if @amount.to_i > 100
      puts "The max bet is 100."
      wager
    else
      puts "Great, you've wagered $#{@amount.to_s}. Let's get started."
    end
    start_game
  end

  def start_game
    @player_card1 = deal_card()
    @dealer_downcard = deal_card()
    @player_card2 = deal_card()
    @dealer_upcard = deal_card()

    @player_hand << value(@player_card1)
    @player_hand << value(@player_card2)

    @dealer_hand << value(@dealer_upcard)
    @dealer_hand << value(@dealer_downcard)

    # @split = false

    game_play
  end

  # def split
  #   @split = true
  #   puts "You got #{name(@player_card1)} and #{name(@player_card2)}, which have the same value, would you like to split?"
  #   yes_or_no = gets.chomp.downcase
  #   if yes_or_no == "yes"
  #     ####################
  #     @new_first_hand = [@player_card1]
  #     @second_card_first_hand = deal_card()
  #     @new_first_hand << @second_card_first_hand
  #     @new_second_hand = [@player_card2]
  #     @second_card_second_hand = deal_card()
  #     @new_second_hand << @second_card_second_hand
  #     after_split_first(@new_first_hand)
  #     after_split_second(@new_second_hand)
  #   else 
  #     puts "The dealer is showing " + name(@dealer_upcard)
  #     puts "Would you like to hit or stay? (reply 'hit' OR 'stay')"
  #     @answer = gets.chomp
  #   end
  # end

  # def after_split_first(hand)
  #   puts "Let's handle this hand first."
  #   puts "You were dealt #{@second_card_first_hand} to go with #{@player_card1} for a total of #{player_total(@new_first_hand)}."
  #   puts "The dealer is showing #{name(@dealer_upcard)}."
  #   puts "Would you like to hit or stay? (Enter: 'hit' or 'stay')"
  #   first_split = gets.chomp.downcase
  #   if first_split == 'hit'
  #     split_card_1 = deal_card()
  #     @new_first_hand << split_card_1
  #     puts "your new total for this hand is #{player_total(@new_first_hand)}"
  #     hit_question()
  #     hit_or_stay(@new_first_hand)
  #   else
  #     puts ""
  #   end
  # end

  # def after_split_second(hand)
  # end

  def game_play
    puts "You have a " + name(@player_card1) + " and a " + name(@player_card2) +
    " for a total of " + player_total(@player_hand).to_s

    if player_total(@player_hand) == 21
      puts "You got blackjack!"
      pick_winner
      unless (@dealer_upcard == 1 || @dealer_upcard >= 10) 
        puts "You win!"
      end
    # elsif player_total <= 11
    #   puts "You have #{player_total}. Do you want to double down?"
    #   ####################################
    # elsif value(@player_card1) == value(@player_card2)
    #   split
    else
      puts "The dealer is showing " + name(@dealer_upcard)
      hit_question
      hit_or_stay(@player_hand)
    end
  end

  def hit_question
    puts "Would you like to hit or stay? (reply 'hit' OR 'stay')"
    @answer = gets.chomp
  end

  def deal_card
    @deck.shuffle!.pop
  end

  def name(card)
    if card == 1
      card_name = "ace"
    elsif card == 11
      card_name = "jack"
    elsif card == 12
      card_name = "queen"
    elsif card == 13
      card_name = "king"
    else
      card_name = card.to_s
    end
  end

  def value(card)
    if card == 1
      card = 11
    elsif card > 10
      card = 10
    else
      card
    end
  end

  def player_total(hand)
    # @player_hand.inject(:+)
    p "hand: #{hand}"
    total = hand.inject(:+)
    if total > 21 && @player_hand.include?(11)
      hand.delete(11)
      hand << 1
      p "ace_adjustment: #{hand}"
      total = hand.inject(:+)
    else 
      total = @player_hand.inject(:+)
    end
    total
  end

  # def ace_case
  # end

  def dealer_total
    # value(@dealer_upcard) + value(@dealer_downcard)
    @dealer_hand.inject(:+)
  end

  def hit_or_stay(hand)
    while @answer.downcase != 'stay' && player_total(hand) < 21
      if @answer.downcase == 'hit'
        @another_card = deal_card
        hand << value(@another_card)
        puts "You drew a " + name(@another_card)
        
        p player_total(hand)
        puts "Your new total is " + player_total(hand).to_s
        if player_total(hand) == 21
          @answer = 'stay'
        elsif player_total(hand) > 21
          @answer = 'stay'
          player_busted?(hand)
        else
          puts "Would you like to hit again or stay?"
          @answer = gets.chomp
        end
      else
        puts "Please only enter 'hit' OR 'stay'"
        @answer = gets.chomp
      end
    end
    reveal_downcard
  end

  def reveal_downcard
    puts "Dealer reveals a " + name(@dealer_downcard) + " and has a total of " + dealer_total.to_s
    dealer_hits_or_stays
  end

  def player_busted?(hand)
    if player_total(hand) > 21
      puts "You busted sucker!"
      @busted = true
    else
      @busted = false
    end
  end

  def dealer_busted?
    if dealer_total > 21
      puts "Dealer busted"
      @dealer_busted = true
    else
      @dealer_busted = false
    end
  end

  def dealer_hits_or_stays
    while dealer_total <= 16
      another_card = deal_card
      puts dealer_total
      @dealer_hand << value(another_card)
      puts dealer_total
      puts "The dealer drew a(n) " + name(another_card) + " for a new total of " + dealer_total.to_s
    end
    dealer_busted?
    pick_winner
  end

  def results
    if @@bankroll == 0
      puts "You're even!"
    elsif @@bankroll > 0
      puts "You're up $#{@@bankroll.to_i}!"
    else
      puts "You're down $#{@@bankroll.to_i}!"
    end
  end

  def pick_winner(hand=@player_hand)
    puts "The player has " + player_total(hand).to_s

    if(player_total(hand) == dealer_total && @busted == false)
      puts "Dealer and player tie. It's a push."
    elsif(player_total(hand) > dealer_total && @busted == false) || (@busted == false && @dealer_busted == true)
      puts "Player wins " + player_total(hand).to_s + " to " + dealer_total.to_s
      if @gambler
        @@bankroll += @amount
        puts "you won #{@amount}"
        if @@bankroll > 0
          puts "you've won #{@@bankroll}"
        else
          puts "you've lost #{@@bankroll}"
        end
      end
    else
      puts "Dealer wins " + dealer_total.to_s + " to " + player_total(hand).to_s
      if @gambler
        @@bankroll -= @amount
        puts "you lost #{@amount}"
        if @@bankroll > 0
          puts "you've won #{@@bankroll}"
        else
          puts "you've lost #{@@bankroll}"
        end
      end
    end
    play_again
  end

  def play_again
    puts "Would you like to play another hand? ('yes' or 'no')"
    response = gets.chomp.downcase
    if response == "yes"
      another = Blackjack.new
      another.start
    else
      puts "Thanks for playing!"
    end
  end
end 

class DoubleDown < Blackjack
  def initialize(total)

  end
end 

b = Blackjack.new
b.start

