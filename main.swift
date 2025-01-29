// COSC 295 Assignment 1 
// Blackjack
// Patreece Eichel & John Lazaro

public struct Balance : CustomStringConvertible 
{
  private var balance : Double = 100.00; 

  // Retrieves the balance
  public func getBalance() -> Double 
  {
    return balance;
  }

  // Reduces the balance by the provided amount
  public func reduceBalance(amount: Double) 
  {
    balance -= amount;
  }

  // Increases the balance by the provided amount
  public func increaseBalance(amount: Double)
  {
    balance += amount;
  }
}


print("Welcome to Blackjack!\n");

