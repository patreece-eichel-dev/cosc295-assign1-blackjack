// COSC 295 Assignment 1 
// Blackjack
// Patreece Eichel & John Lazaro

enum cardSuit: Int { case SPADE = 1, CLUBS, DIAMOND, HEART }
enum cardVal: Int { case ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING } 

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
      handValue += card.value;
    }
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

/**
 * This is the card class that will be used as a reference for the deck and 
 * players hands
 */
struct Card {
  private var suit: cardSuit
  private var val: cardVal
  var value: cardVal { 
    get {
      return value
    }
  }

  init(suit: cardSuit, val: cardVal) {
    self.suit = suit
    self.val = val
  }

  func toString() -> String {
    return "\(value) of \(suit)"
  }
}

/**
 * This is the deck class that represents the deck of cards that will be drawn from
 */
class Deck {
  private var cards: [Card]

  /**
   * This method will initialize the deck with 52 card
   */
  init () {
    // Initialize the deck with 52 cards
    for suit in 1...4 {
      for value in 1...13 {
        // did new line for readability
        var newCard = Card(suit: cardSuit(rawValue: suit)!, val: cardVal(rawValue: value)!)
        self.cards.append(newCard)
      }
    }
  }

  /**
   * This method is created in to deal with the array being private
   */
  func shuffle() {
    // Shuffle the deck
    self.cards.shuffle()
  }

  /**
   * This method will remove a card from the top and place it into a players hand
   */
  func drawCard() -> Card {
    return self.cards.remove(at: 0)
  }
}

main()