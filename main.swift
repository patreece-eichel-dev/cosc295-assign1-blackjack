enum cardSuit: Int { case SPADE = 1, CLUBS, DIAMOND, HEART }
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
  func drawCard(player: Player) -> Card {
    return self.cards.remove(at: 0)
  }
}

func main () {
  var gameActive: Bool = true
  var deck: Deck
  deck.shuffle()

  while (gameActive) {
    
  }
}

main()