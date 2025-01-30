// COSC 295 Assignment 1 
// Blackjack
// Patreece Eichel & John Lazaro

enum cardSuit: Int { case SPADE = 1, CLUBS, DIAMOND, HEART }
enum cardVal: Int { case ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING } 

public func main() {
  var winner: BlackJackParticipant? = nil;
  
  // generate the players and the deck
  var player: BlackJackParticipant = Player(numCards: 2, deck: deck);
  var dealer: BlackJackParticipant = Dealer(numCards: 2, deck: deck);
  
  print("Welcome to BlackJack!\n");
  var roundNum: Int = 1;

  // play until someone wins
  while winner == nil {
    print("Round \(roundNum += 1)\n");
    winner = playRound(player: player, dealer: dealer);
  }
  // announce winner
  print("Congrats to \(winner) for winning the game!");
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
      return val
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
    cards = Array<Card>()
    for suit in 1...4 {
      for value in 1...13 {
        // did new line for readability
        let newCard: Card = Card(suit: cardSuit(rawValue: suit)!, val: cardVal(rawValue: value)!)
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

/**
* Defines blackjack actions that can be performed by the dealer and the player
*/
protocol BlackJackActions {
  func hit(deck : Deck) -> Card 
  func checkHandValue() -> Int
}

/**
*  Parent class for the dealer and player of the blackjack game
*/
class BlackJackParticipant : BlackJackActions {

  private var description: String = "Dealer";
  private var hand: [Card] = Array<Card>(); // holds the participants hand of cards
  public var Hand: [Card] {
    get {
      return hand;
    }
  }

  // Initialize a participant with a hand of cards
  public init(numCards : Int, deck : Deck) {
    for _ in 0...numCards {
      hand.append(deck.drawCard());
    }
  }
  
  // Allows player to draw a card from the deck and add it to their hand
  func hit(deck: Deck) -> Card{
    var newCard = deck.drawCard();
    hand.append(newCard);
    return newCard;
  }

  // Calculate the value of the cards in their hand
  func checkHandValue() -> Int {
    var handValue: Int = 0;
    for card: Card in hand {
      handValue += card.value.rawValue;
    }
    return handValue;
  }
}


/**
* Player class for creating a player that can perform blackjack actions
* and work with their balance
*/
class Player : BlackJackParticipant {
  
  private var description: String = "Player";
  private var balance : Balance; // keeps track of balance (bet amount)

  // initialize player with 100.00 balance
  public override init(numCards: Int, deck targetedDeck: Deck) {
    self.balance = Balance(startingBalance: 100.00);
    super.init(numCards : numCards, deck : targetedDeck);
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
class Dealer : BlackJackParticipant {

  private var faceUpCard : Card?;
  
  // Initialize a dealer with a hand of cards
  public override init(numCards : Int, deck targetedDeck: Deck) {
    self.faceUpCard = nil
    super.init(numCards : numCards, deck: targetedDeck);
    var upCard:Int = Int.random(in: 0...self.Hand.count)  // get random as needed within the range
    self.faceUpCard = self.Hand[upCard];

  }

  public func viewFaceUpCard() -> Card {
    return faceUpCard!;
  }
}

/**
* Balance class tracks the balance of the player
* you can add or subtract from the balance appropriatelu
*/
class Balance {
  private var balance: Double; 

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
func playRound(player: BlackJackParticipant, dealer: BlackJackParticipant) -> BlackJackParticipant? {
  // assert that an active round is in session
  var activeRound: Bool = true

  // ask the user how much will the be betting
  print("Place your bets!!: \n")

  // while the round is still active
  while (activeRound) {
    // prompt the user on what action they will take
    print("What will you do? Actions: [h]it, [s]tand, replace [d]ealer card, replace [l]ast dealt card")
    var action: String = readLine()!

    // handle the action that the user has specified
    switch(action) {
      case "h":
        player.hit()
        break;
      case "s"
       break;
      case "d"
       break;
      case "l"
       break;
    }
  }

  return nil;
}

main()