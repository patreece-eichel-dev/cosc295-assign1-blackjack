// COSC 295 Assignment 1 
// Blackjack
// Patreece Eichel & John Lazaro

enum cardSuit: Int { case SPADE = 1, CLUBS, DIAMOND, HEART }
enum cardVal: Int { case ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING } 

public func main() {
  // Generate the deck that will be used
  var deck: Deck = Deck();
  
  // generate the players and the deck
  let player: Player = Player(deck: deck, description : "Player");
  let dealer: Dealer = Dealer(deck: deck, description : "Dealer");
  
  var winner: BlackJackParticipant? = nil;
  
  print("Welcome to BlackJack!\n");
  var roundNum: Int = 0;

  // play until someone wins
  while winner == nil {
    deck.shuffle();
    roundNum += 1;
    print("Round \(roundNum)\n");
    
    winner = playRound(player: player, dealer: dealer);
    deck = Deck();
  }
  // announce winner
  print("Congrats to \(winner!.description) for winning the game!");
  
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
        var newCard: Card = Card(suit: cardSuit(rawValue: suit)!,
                                 val: cardVal(rawValue: value)!)
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
  func hit() -> Card
  func checkHandValue() -> Int
}

/**
*  Parent class for the dealer and player of the blackjack game
*/
class BlackJackParticipant : BlackJackActions {
  internal var description: String;
  internal var hand: [Card] = Array<Card>(); // holds the participants hand of cards
  internal var deck: Deck

  // Initialize a participant with a hand of cards
  public init(deck : Deck, description: String) {
    self.description = description;
    self.deck = deck;
  }
  
  // Allows player to draw a card from the deck and add it to their hand
  func hit() -> Card {
    var newCard: Card = deck.drawCard();
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
  
  private var balance : Balance; // keeps track of balance (bet amount)
  private var bet : Double;

  // initialize player with 100.00 balance
  public override init(deck targetedDeck: Deck, description: String = "Player") {
    self.balance = Balance(startingBalance: 100.00);
    self.bet = -1.00; // force them to set a bet
    super.init(deck : targetedDeck, description: description);
  }

  // prints out tha cards in their hand and the total value
  public func viewHand() {
    print ("Current hand:")
    for card in 0..<self.hand.count {
      print("\(self.hand[card].toString())")
    }
    print("Current hand value: \(self.checkHandValue())\n");
  }

  // For half of their current bet, 
  //the player can force the dealer to draw a replacement card
  public func replaceDealerCard(dealer: Dealer) {
    self.balance.reduceBalance(amount: 0.5 * self.balance.getBalance()); // reduce bet/balance by 50%
    dealer.replaceFaceUpCard();
  }

  // For 25% of their current bet, 
  // the player can replace the card that they drew last 
  public func replaceLastDealtCard() {
    self.balance.reduceBalance(amount: 0.25 * self.balance.getBalance()); // reduce balance by 25%
    hand[hand.count - 1] = self.deck.drawCard(); // replace last card in hand with a new one
  }

  // takes the amount the player wishes to bet
  public func placeBet() {
    while (self.bet > self.balance.getBalance() || bet <= 0.00) {
      print("Enter your bet amount between $0.01 and $\(self.balance.getBalance()): ");
      self.bet = Double(readLine()!)!;
    }
  }

   public func getRules() -> String {
    return "BlackJack Rules\n You will start with a balance of $100.00\n" +
            "You can bet $0.01 up to the amount of your balance.\n" +
            "if you win, the amount that you bet will be added to your balance." +
            " If you lose, that amount will be deducted from your balance.\n" +
            "The objective of the game is to get as close to 21 as possible without going over and causing a bust\n" +
            "OR to draw a Black Jack which means an automatic win\n" +
            "During the game you are allowed to hit, stand, replace the dealer's face up card, and replace your last dealt card\n" +
            "The game will end when a winner is determined, you choose to quit, or your balance runs out\n" + 
            "Below the actions you can take are described in detail:\n" +
            "[h]it: draw a \n" +
            "[s]tand: \n" +
            "replace [d]ealer card: \n" +
            "replace [l]ast dealt card: \n";
  }
}

/**
* Dealer class for creating a dealer that can perform blackjack actions
*/
class Dealer : BlackJackParticipant {

  // optional because it can only happen after cards have been dealt
  internal var faceUpCard : Card?; 
  
  // Initialize a dealer with a hand of cards
  public override init(deck targetedDeck: Deck, description : String) {
    super.init(deck: targetedDeck, description: description);
  }

  // takes a random card in the dealers hand and turns it face up
  public func turnCardFaceUp() {
    self.faceUpCard =  self.hand[Int.random(in: 0..<self.hand.count)];
  }

  // prints the faceup card in the dealers hand
  // flips one if there isn't one
  public func viewFaceUpCard() {
    print("Dealer's face-up card:");
    if self.faceUpCard == nil {
      self.turnCardFaceUp();
    } 
    print("\((self.faceUpCard!).toString())\n");
  }

  // replaces faceup card with a new one from the deck
  public func replaceFaceUpCard() {
    self.faceUpCard = self.deck.drawCard();
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
func playRound(player: Player, dealer: Dealer) -> BlackJackParticipant? {
  // assert that an active round is in session
  var activeRound: Bool = true

  // ask the user how much will the be betting before each round
  player.placeBet();

  // each draw 2 cards into hand
  for _ in 0..<2 {
    player.hit();
    dealer.hit();
  }

  // while the round is still active
  while (activeRound) {

    // show the hand
    player.viewHand();

    // show dealers face up card, flipping one if there isn't one already face up
    dealer.viewFaceUpCard();
    
    print("What will you do? Actions: [h]it, [s]tand, replace [d]ealer card, replace [l]ast dealt card, [v]iew rules")
    var action: String = readLine()!
    
    // handle the action that the user has specified
    switch(action) {
      case "h":
        print("Drawn Card: \(player.hit().toString())\n" + 
        "New Hand Value: \(player.checkHandValue())\n");
        break;
      case "s":
        activeRound = false
        break;
      case "d":
        player.replaceDealerCard(dealer: dealer);
       break;
      case "l":
        player.replaceLastDealtCard();
       break;
      case "v":
        print(player.getRules());
       break;
      default:
       break;
    }

    if (player.checkHandValue() > 21) {
      print("You Lose!")
      return dealer;
    }
  }

  if (player.checkHandValue() > dealer.checkHandValue()) {
    print("You Win!")
    return player;
  } else {
    print("You Lose!")
    return dealer;
  }
}

main()