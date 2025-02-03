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

  var cont: Bool = true

  print("Welcome to BlackJack!\n");
  var roundNum: Int = 0;

  // play you go broke or if you quit
  while cont {
    player.clearHand();
    dealer.clearHand();
    deck.shuffle();
    roundNum += 1;
    print("Round \(roundNum)\n");

    let winner = playRound(player: player, dealer: dealer);
    deck = Deck();

    // announce winner
    if (winner?.description == "Tie") {
      print("It was a tie"); 
    } else {
      print("Congrats to \(winner!.description) for winning round \(roundNum)!\n");
    }
    
    if (player.bal.getBalance() <= 0) {
      print("You have gone broke! No more gambling! Game Over\n");
      cont = false;
    } else {
      print("Continue to play? (y/n)");
      cont = readLine() == "y";
    }
  }
  
  print("Thanks for playing!")
}

/**
 * This is the card class that will be used as a reference for the deck and 
 * players hands
 */
struct Card: Equatable {
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
    var cardSymbol = "";

    switch self.suit {
      case .SPADE:
        cardSymbol = "♤";
      case .CLUBS:
        cardSymbol = "♧";
      case .DIAMOND:
        cardSymbol = "♢";
      default:
        cardSymbol = "♡";
    }
    return "\(value) of \(cardSymbol)"
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
        let newCard: Card = Card(suit: cardSuit(rawValue: suit)!,
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
    let newCard: Card = deck.drawCard();
    hand.append(newCard);
    return newCard;
  }

  // Calculate the value of the cards in their hand
  func checkHandValue() -> Int {
    var handValue: Int = 0;
    for card: Card in hand {
      if (card.value.rawValue == 1 && handValue <= 10) { // ace increase on small hand
        handValue += 11;
      } else if (card.value.rawValue == 1 && handValue > 10) { // ace decrease on large hand
        handValue += 1;
      } else if (card.value.rawValue > 1 && card.value.rawValue < 10) { // normal cards
        handValue += card.value.rawValue;
      } else { // face cards
        handValue += 10;
      }
    }
    return handValue;
  }

  func clearHand() {
    hand = Array<Card>();
  }

  func hasBlackJack() -> Bool {
    if (hand[0] == Card(suit: cardSuit.SPADE, val: cardVal.ACE) && hand[1] == Card(suit: cardSuit.SPADE, val: cardVal.JACK)
       || hand[0] == Card(suit: cardSuit.CLUBS, val: cardVal.ACE) && hand[1] == Card(suit: cardSuit.CLUBS, val: cardVal.JACK)
       || hand[0] == Card(suit: cardSuit.SPADE, val: cardVal.JACK) && hand[1] == Card(suit: cardSuit.SPADE, val: cardVal.ACE)
       || hand[0] == Card(suit: cardSuit.CLUBS, val: cardVal.JACK) && hand[1] == Card(suit: cardSuit.CLUBS, val: cardVal.ACE)) {
      return true;
    } else {
      return false;
    }
  }
}


/**
* Player class for creating a player that can perform blackjack actions
* and work with their balance
*/
class Player : BlackJackParticipant {
  private var balance : Balance; // keeps track of balance (bet amount)
  private var bet : Double;

  public var bal: Balance {
    get {
      return balance;
    }
  }
  public var Bet: Double {
    get {
      return bet;
    }
  }

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
    let cost = self.bet * 0.5
    self.bal.reduceBalance(amount: cost);

    dealer.replaceFaceUpCard();
    print("Cost: \(cost) New Balance: \(self.bal.getBalance())");
  }

  // For 25% of their current bet, 
  // the player can replace the card that they drew last 
  public func replaceLastDealtCard() {

    // pay 25% of their current bet
    let cost = self.bet * 0.25; 
    self.bal.reduceBalance(amount: cost);

    // replace last drawn card
    let oldCard =  hand[hand.count - 1];
    let replacement: Card = self.deck.drawCard();
    hand[hand.count - 1] = replacement; // replace last card in hand with a new one

    // show replacement and cost
    print("Card: \(oldCard.toString()) replaced with: \(replacement.toString())");
    print("Cost: \(cost) New Balance: \(self.bal.getBalance())");
  }

  // takes the amount the player wishes to bet
  public func placeBet() {
    repeat {
      print("Enter your bet amount between $0.01 and $\(self.balance.getBalance()): ");
      let betAmount: Double = Double(readLine()!)!;
      self.bet = betAmount;
    } while (self.bet > self.balance.getBalance() || bet <= 0.00)

    self.balance.reduceBalance(amount: self.bet);
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
  // assert that both players are actively taking their turns
  var playerHitting: Bool = true;
  var dealerHitting: Bool = true;

  // ask the user how much will the be betting before each round
  player.placeBet();

  // each draw 2 cards into hand
  for _ in 0..<2 {
    let _ = player.hit();
    let _ = dealer.hit();
  }

  // while the round is still active
  while (playerHitting || dealerHitting) {

    // show the hand
    player.viewHand();

    // show dealers face up card, flipping one if there isn't one already face up
    dealer.viewFaceUpCard();

    // handle the action that the user has specified
    if (playerHitting) {
      print("What will you do? Actions: [h]it, [s]tand, replace [d]ealer card, replace [l]ast dealt card, [v]iew rules")
      let action: String = readLine()!
      switch(action) {
        case "h":
          print("Drawn Card: \(player.hit().toString())\n" + 
          "New Hand Value: \(player.checkHandValue())\n");
          break;
        case "s":
          playerHitting = false
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
          print(player.getRules());
          break;
      }
    }

    if (dealer.checkHandValue() < 17) {
      print("Dealer hit");
      let _ = dealer.hit();
    } else {
      print("Dealer stands");
      dealerHitting = false;
    }
    
    if (dealer.hasBlackJack()) {
      print("Dealer got a blackjack! You lose!");
      return dealer;
    }

    if (player.hasBlackJack()) {
      print("You got a blackjack! You win!");
      return player;
    }

    // player 21
    if (player.checkHandValue() == 21) {
      print("What's 9 + 10? 21! You win!");
      player.bal.increaseBalance(amount: player.Bet * 2);
      return player;
    }

    // dealer 21
    if (dealer.checkHandValue() == 21) {
      print("The dealer got 21. You lose!");
      return dealer;
    }
    
    // dealer bust
   if (dealer.checkHandValue() > 21) {
      print("Dealer got busted by the cops! You Win!")
      player.bal.increaseBalance(amount: player.Bet * 2);
      return player;
    }

    // player bust, allows player to keep drawing new card if they keep going over 21
    // as long as they can afford to do so
    func playerBust() -> BlackJackParticipant {
      print("Bust!");
      var res: String = "";
      repeat {
        print("Your balance: \(player.bal.getBalance()) Would you like to draw a new card for a cost of \(player.Bet * 0.25) (y/n)")
        res = readLine()!;
      } while (res != "y" && res != "n")

      // dealer wins if they chose not to replace
      if (res == "n") {
        return dealer;
      } else {
        print(player.bal.getBalance())
        // if they can afford to replace that's fine
        if (player.bal.getBalance() > 0.00) {
          player.replaceLastDealtCard();
          if (player.checkHandValue() > 21) { // if they bust again they can chose to replace again
            return playerBust();
          }
        // dealer wins if they try to replace and can't afford it
        } else {
          return dealer;
        }
      }
      return player; // if they drew again and didn't go over 21 they can keep playing
    }

    // player bust
    if (player.checkHandValue() > 21) {
      let winner: BlackJackParticipant = playerBust(); 
      // return dealer if player chose not to replace or went broke
      if (winner.description == "Dealer") {
        return winner;
      }
    }

   // dealer bust
    if (dealer.checkHandValue() > 21) {
      print("Dealer got busted by the cops! You Win!")
      player.bal.increaseBalance(amount: player.Bet * 2);
      return player;
    }
  }

  print("Player hand value: \(player.checkHandValue())\nDealer hand value: \(dealer.checkHandValue())\n");
  
  // return winner based on hand value
  if (player.checkHandValue() > dealer.checkHandValue()) {
    print("Your cards have higher value than the dealer. You Win!")
    player.bal.increaseBalance(amount: player.Bet * 2);
    return player;
  } else if (player.checkHandValue() < dealer.checkHandValue()) {
    print("You have less than the dealer. You Lose!")
    return dealer;
  } else { // tie
    return BlackJackParticipant(deck: Deck(), description: "Tie");
  }
}

main()