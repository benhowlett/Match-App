//
//  ViewController.swift
//  Match App
//
//  Created by Benjamin Howlett on 2019-03-02.
//  Copyright © 2019 Benjamin Howlett. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 30 * 1000 // 10 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create a scheduled timer for the count down
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
        
    }
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // When the timer has reached 0
        if milliseconds <= 0 {
            
            // Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any unmatched cards
            checkGameEnded()
            
        }
        
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there is any time left
        if milliseconds <= 0 {
            return
        }
        
        // Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if !card.isFlipped && !card.isMatched{
            
            // Flip the cell
            cell.flip()
            
            // Play the flip sound
            SoundManager.playSound(.flip)
            
            // Set the flipped status of the card to true
            card.isFlipped = true
            
            // Determine if this is the first or second card flipped
            if firstFlippedCardIndex == nil {
                
                // This is the first card being flipped
                firstFlippedCardIndex = indexPath
            }
            else {
                
                // This is the second card flipped
                checkForMatches(indexPath)
                
            }
        
        }
        
        
    } // End the didSelectItemAt method
    
    // MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the cells for the 2 cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the 2 cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Check if the cards match
        
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            
            // Play match sound
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            
            // Check if any cards are left unmatched
            checkGameEnded()
            
        }
        else {
            
            // It's not a match
            
            // Play no match sound
            SoundManager.playSound(.noMatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip cards back over
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            
            
        }
        
        // Tell the collectionView to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        
        var isWon = true
        
        // Check if any cards unmatched
        for card in cardArray {
            if !card.isMatched {
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // If not, then user has won, stop the timer
        if isWon {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
        
            title = "Congratulations!"
            message = "You've won"
            
        }
        else {
            
            // If there are, check if there is any time left
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
            
        }
        
        // Show won/lost message
        showAlert(title, message)
        
    }
    
    func showAlert(_ title: String, _ message: String) {
        // Create alert
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        // Create alert action
        let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        
        // Add action to alert
        alert.addAction(alertAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }


} // End ViewController Class

