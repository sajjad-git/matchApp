//
//  CardCollectionViewCell.swift
//  matchApp
//
//  Created by Sajad on 2020-06-24.
//  Copyright © 2020 camelKase. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func configureCell(card: Card) {
        // Keep track of the card this cell repreents
        self.card = card;
        // Set the front image view to the image that represeents the card
        frontImageView.image = UIImage(named: card.imageName);
        
        // Reset the state of the cell by checking the status of the card and then showing the front or the back of the card accordingly
        if (card.isMatched) {
            frontImageView.alpha = 0;
            backImageView.alpha = 0;
            return
        } else {
            frontImageView.alpha = 1;
            backImageView.alpha = 1;
        }
        
        if (card.isFlipped) {
            // Show the front image view
            flipUp(speed: 0);
        } else {
            //show the ba ck image view
            flipDown(speed: 0, delay: 0);
        }
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        // Flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil);
        
        // Set the status of the card
        card?.isFlipped = true;
        
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        // Flip down animation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil);
        }
        card?.isFlipped = false;
    }
    
    func remove() {
        // Make the image views invisible
        backImageView.alpha = 0;
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0;
        }, completion: nil)
    }
}
