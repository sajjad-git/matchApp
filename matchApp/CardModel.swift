//
//  cardModel.swift
//  matchApp
//
//  Created by Sajad on 2020-06-22.
//  Copyright © 2020 camelKase. All rights reserved.
//

import Foundation

class CardModel  {
    func getCards() -> [Card] {
        // Declare an array
        var generatedCards = [Card]()
        
        // keep track of cards
        // This was done to speed-up the process and used less memory in the while loop
        var generatedNums = [Int]()
        
        // Randomly generate 8 pairs of cards
        while generatedCards.count < 16 {
            // Generate a random number
            let generatedCardNum: Int = Int.random(in:1...13)
            
            // Make sure generatedCards does not already contain the card
            if !generatedNums.contains(generatedCardNum) {
                
                generatedNums.append(generatedCardNum)
                
                let card1 = Card()
                let card2 = Card()
                
                // Set their image names
                card1.imageName = "card\(generatedCardNum)"
                card2.imageName = "card\(generatedCardNum)"
                
                // Append the generated card objects to the cards array
                generatedCards += [card1, card2]
            }            
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()
        // Return the array
        return generatedCards
    }
}
