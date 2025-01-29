enum cardSuit { case SPADE, CLUBS, DIAMOND, HEART }
enum cardVal: Int { case ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING } 

/**
 * This is the card class that will be used as a reference for the deck and 
 * players hands
 */
struct Card {
  private var suit: cardSuit
  private var value: cardVal

  init(suit: cardSuit, val: cardVal) {
    self.suit = suit
    self.value = val
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
    for suit in cardSuit {
      for value in cardVal {
        self.cards.append(Card(suit: suit, val: value))
      }
    }
  }

  /**
   * 
   */
  // func drawCard(player: Player) -> Card {
  //  
  // }
}

func main () {
  var gameActive: Bool = true
  initGame()

  while (gameActive) {
    
  }
}

/**
 * This method will initialize the game
 */
func initGame () {
  
}

main()