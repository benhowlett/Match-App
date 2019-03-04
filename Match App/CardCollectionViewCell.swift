//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Benjamin Howlett on 2019-03-02.
//  Copyright © 2019 Benjamin Howlett. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        
        // Keep track of the card that gets passed in
        self.card = card
        
        // Check if card is matched
        if card.isMatched {
            
            // Keep it hidden if it has already been matched
            frontImageView.alpha = 0
            backImageView.alpha = 0
            
            return
        }
        else {
            
            // Make sure it is visible if they haven't been matched
            frontImageView.alpha = 1
            backImageView.alpha = 1
            
        }
        
        // Set the front image to the image of the card passed in
        frontImageView.image = UIImage(named: card.imageName)
        
        // Determine if card is flipped or not
        if card.isFlipped {
            
            // Display front image view
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        }
        else {
            
            // Display back image view
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil) 
            
        }
        
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options:  [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        // Delay the flip back to let the user see that it wasn't a match
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
        
    }
    
    func remove() {
        
        // Removes both image views from being visible
        backImageView.alpha = 0
        
        // animate it
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)
        
        
        
    }
    
}
