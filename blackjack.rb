class Blackjack
  attr_accessor :deck, :player_hand
  
  @@bankroll = 0

  def initialize
    suit = (1..13).to_a
    @deck = suit * 4
    p @deck.count
    @player_hand = []
    @dealer_hand = []
    @busted = false
    @dealer_busted = false
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
    puts "Great, you've wagered $#{@amount.to_s}. Let's get started."
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

    game_play
  end

  def split
    puts "You got #{name(@player_card1)} and #{name(@player_card2)}, which have the same value, would you like to split?"
    yes_or_no = gets.chomp.downcase
    if yes_or_no == "yes"
      ####################
    end
  end

  def game_play
    puts "You have a " + name(@player_card1) + " and a " + name(@player_card2) +
    " for a total of " + player_total.to_s

    if player_total == 21
      puts "You got blackjack!"
      pick_winner
      unless (@dealer_upcard == 1 || @dealer_upcard >= 10) 
        puts "You win!"
      end
    elsif value(@player_card1) == value(@player_card2)
      split
    else
      puts "The dealer is showing " + name(@dealer_upcard)
      puts "Would you like to hit or stay? (reply 'hit' OR 'stay')"
      @answer = gets.chomp

      hit_or_stay()
    end
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

  def player_total
    @player_hand.inject(:+)
    # if total > 21 && @player_hand.include(11)
  end

  def dealer_total
    # value(@dealer_upcard) + value(@dealer_downcard)
    @dealer_hand.inject(:+)
  end

  def hit_or_stay
    while @answer.downcase != 'stay' && player_total < 21
      if @answer.downcase == 'hit'
        @another_card = deal_card
        @player_hand << @another_card
        puts "You drew a " + name(@another_card)
        
        p player_total
        puts "Your new total is " + player_total.to_s
        if player_total == 21
          @answer = 'stay'
        elsif player_total > 21
          @answer = 'stay'
          busted?
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

  def busted?
    if player_total > 21
      puts "You busted sucker!"
      @busted = true
    else
      @busted = false
    end

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
    busted?
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

  def pick_winner
    puts "The player has " + player_total.to_s

    if(player_total == dealer_total && @busted == false)
      puts "Dealer and player tie. It's a push."
    elsif(player_total > dealer_total && @busted == false) || (@busted == false && @dealer_busted == true)
      puts "Player wins " + player_total.to_s + " to " + dealer_total.to_s
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
      puts "Dealer wins " + dealer_total.to_s + " to " + player_total.to_s
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

b = Blackjack.new
b.start

