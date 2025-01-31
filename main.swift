// COSC 295 Assignment 1 
// Blackjack
// Patreece Eichel & John Lazaro

public func main() {
  var winner = nil;
  
  print("Welcome to BlackJack!\n");
  var roundNum = 1;

  // play until someone wins
  while winner == nil {
    print("Round \(roundNum++)\n");
    playRound();
  }
  // announce winner
  print("Congrats to \(winner) for winning the game!");
}

/**
* Defines blackjack actions that can be performed by the dealer and the player
*/
public protocol BlackJackActions {
  public func hit(deck : Deck) -> Card 
  public func checkHandValue() -> Int
}

/**
*  Parent class for the dealer and player of the blackjack game
*/
public class BlackJackParticipant : BlackJackActions {

  private var description = "Dealer";
  private var hand = Array<Card>(); // holds the participants hand of cards

  // Initialize a participant with a hand of cards
  public init(numCards : Int, deck : Deck) {
    for _ in numCards {
      hand.append(deck.drawCard());
    }
  }
  
  // Allows player to draw a card from the deck and add it to their hand
  public func hit(deck: Deck) {
    hand.append(Deck.drawCard());
  }

  // Calculate the value of the cards in their hand
  public func checkHandValue() -> Int {
    var handValue = 0;
    for card in hand {
      handValue += card.getValue();
    }
  }

  // draw a new card to replace the last card
  public func replaceLastDraw(deck: Deck) {
    hand[hand.count - 1] = deck.drawCard();
  }
}


/**
* Player class for creating a player that can perform blackjack actions
* and work with their balance
*/
public class Player : BlackJackParticipant {
  
  private var description = "Player";
  private var balance : Balance; // keeps track of balance (bet amount)

  // initialize player with 100.00 balance
  public init(numCards: Int) {
    self.balance = Balance(startingBalance: 100.00);
    super.init(numCards : numCards, deck : Deck);
  }

  // For half of their current bet, 
  //the player can force the dealer to draw a replacement card
  public func replaceDealerCard() {
    self.balance -= 0.50 * balance; // reduce bet/balance by 50%
    dealer.replaceFaceUpCard(deck.drawCard());
  }

  // For 25% of their current bet, 
  // the player can replace the card that they drew last 
  public func replaceLastDealtCard(deck: Deck) {
    self.balance -= 0.25 * balance; // reduce bet/balance by 25%
    self.replaceLastDealtCard(deck);
  }
}


/**
* Dealer class for creating a dealer that can perform blackjack actions
*/
public class Dealer : BlackJackParticipant {

  private var faceUpCard : Card;
  
  // Initialize a dealer with a hand of cards
  public init(numCards : Int, deck: Deck) {
    super.init(numCards : numCards, deck: Deck);
  }

  public func viewFaceUpCard() -> Card {
    return faceUpCard;
  }
}

/**
* Balance class tracks the balance of the player
* you can add or subtract from the balance appropriatelu
*/
public struct Balance {
  private var balance; 

  // Initialize the Balance with a starting value
  public init(startingBalance: Double){
    balance = startingBalance;
  }

  // Retrieves the balance
  public func getBalance() -> Double {
    return balance;
  }

  // Reduces the balance by the provided amount
  public func reduceBalance(amount: Double) {
    balance -= amount;
  }

  // Increases the balance by the provided amount
  public func increaseBalance(amount: Double) {
    balance += amount;
  }
}

/**
* Simulates a round of gameplay
* Returns the winning participant if there is a winner
*/
public func playRound() -> BlackJackParticipant? {
  
}



main();