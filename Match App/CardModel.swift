//
//  CardModel.swift
//  Match App
//
//  Created by Benjamin Howlett on 2019-03-02.
//  Copyright © 2019 Benjamin Howlett. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array to store numbers we've already generated
        var generatedNumbersArray = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                // Log the number
                print(randomNumber)
                
                // Store the number in the generated numbers array
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                // Add first card object to the generated array
                generatedCardsArray.append(cardOne)
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                // Add second card object to the generated array
                generatedCardsArray.append(cardTwo)
                
                
            }
            
        }
        
        // Randomize the array
        generatedCardsArray.shuffle()
        
        // Return the array
        return generatedCardsArray
    }
    
}
