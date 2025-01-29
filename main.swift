// COSC 295 Assignment 1 
// Blackjack
// Patreece Eichel & John Lazaro

public func main() {
  print("Welcome to BlackJack!");
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

  public func checkHandValue() -> Int {
    // add up the values of all cards in hand
  }
}


/**
* Player class for creating a player that can perform blackjack actions
* and work with their balance
*/
public class Player : BlackJackParticipant {
  
  private var balance : Balance; // keeps track of balance (bet amount)

  // initialize player with 100.00 balance
  public init(numCards: Int) {
    self.balance = Balance(startingBalance: 100.00);
    super.init(numCards : numCards, deck : Deck);
  }

  // For half of their current bet, 
  //the player can force the dealer to draw a replacement card
  public func replaceDealerCard() {
    
  }

  // For 25% of their current bet, 
  // the player can replace the card that they drew last 
  public func replaceLastDealtCard() {
    
  }
}


/**
* Dealer class for creating a dealer that can perform blackjack actions
*/
public class Dealer : BlackJackParticipant {

  // Initialize a dealer with a hand of cards
  public init(numCards : Int, deck: Deck) {
    super.init(numCards : numCards, deck: Deck);
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
*/
public func playRound() {
  
}

main();