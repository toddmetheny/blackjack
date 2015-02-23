suit = (1..13).to_a
@deck = suit * 4
p @deck.count

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

@player_hand = []

player_card1 = deal_card
dealer_downcard = deal_card
player_card2 = deal_card
dealer_upcard = deal_card

@player_hand << value(player_card1)
@player_hand << value(player_card2)

def your_total
  @player_hand.inject(:+)
  # if total > 21 && @player_hand.include(11)
end

puts "You have a " + name(player_card1) + " and a " + name(player_card2) +
" for a total of " + your_total.to_s

if your_total == 21
  puts "You got blackjack!"
  unless dealer_upcard == 1 || dealer_upcard >= 10
    puts "You win!"
  end
else
  puts "The dealer is showing " + name(dealer_upcard)
  puts "Would you like to hit or stay? (reply 'hit' OR 'stay')"
  answer = gets.chomp

  while answer.downcase != 'stay' && your_total < 21
    if answer.downcase == 'hit'
      another_card = deal_card
      @player_hand << another_card
      puts "You drew a " + name(another_card)
      
      p your_total
      puts "Your new total is " + your_total.to_s
      if your_total == 21
        answer = 'stay'
      elsif your_total > 21
        answer = 'stay'
      else
        puts "Would you like to hit again or stay?"
        answer = gets.chomp
      end
    else
      puts "Please only enter 'hit' OR 'stay'"
      answer = gets.chomp
    end
  end
end

# if your_total > 21 && @player_hand.include?(11)
#   p @player_hand
#   @player_hand.each do |c|
#     if c == 11
#       c = 1
#       p your_total
#     end
#     p @player_hand
#   end 
#   puts your_total
# end

if your_total > 21
  puts "You busted sucker!"
  busted = true
else
  busted = false
end

dealer_total = value(dealer_upcard) + value(dealer_downcard)
puts "Dealer reveals a " + name(dealer_downcard) + " and has a total of " + dealer_total.to_s

while dealer_total <= 16
  another_card = deal_card
  dealer_total += value(another_card)
  puts "The dealer drew a(n) " + name(another_card) + " for a new total of " + dealer_total.to_s
end

if dealer_total > 21
  puts "Dealer busted"
  dealer_busted = true
else
  dealer_busted = false
end

puts "The player has " + your_total.to_s

if (your_total == dealer_total && busted == false)
  puts "Dealer and player tie. It's a push."
elsif (your_total > dealer_total && busted == false) || (busted == false && dealer_busted == true)
  puts "Player wins " + your_total.to_s + " to " + dealer_total.to_s
else
  puts "Dealer wins " + dealer_total.to_s + " to " + your_total.to_s
end

p @deck.count
