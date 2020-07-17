//
//  ViewController.swift
//  matchApp
//
//  Created by Sajad on 2020-06-22.
//  Copyright © 2020 camelKase. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    
    var cardsArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    var timer: Timer?
    
    var milliseconds: Int = 20 * 1000;
    
    var soundPlayer = SoundManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true);
        RunLoop.main.add(timer!, forMode: .common);
    }
    
    // Play the shuffle sounds a soon as the elements show on the screen
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle sounds
        soundPlayer.playSound(effect: .shuffle)
    }
    
    
    // MARK: - Timer methods
    
    @objc func timerFired() {
        // Decrement the counter
        milliseconds -= 1;
        // Update the label
        let seconds: Double = Double(milliseconds)/1000.0;
        
        timerLabel.text = String(format: "Time remaining: %0.2f seconds", seconds);
        
        
        // Stop the timer if it reaches zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red;
            timer?.invalidate();
        
            // Check if the user has cleared all the cards
            checkForGameEnd()
        }
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Configure the state of the cell based on the properties of the card that it represents
        // Get the card form the card array
        let cardCell = cell as? CardCollectionViewCell;
        
        let card = cardsArray[indexPath.row]
        
        // configuring the cell
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)
        
        // Check if there's any time remaining. Don't let the user interact if the time is 0
        
        if milliseconds <= 0 {
            return 
        }
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell;
        
        // check the status of the card to determine how to flip it
        if (cell?.card?.isFlipped == false && cell?.card?.isMatched == false) {
            // flip the card up
            cell?.flipUp();
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first card that was flipped or the second card
            if (firstFlippedCardIndex == nil) {
                
                // this is the first card flipped over
                firstFlippedCardIndex = indexPath;
            }
            else {
                // this is the second card that is flipped
                
                // Run the comparison logic
                checkForMatch(indexPath);
            }
        }
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row];
        let cardTwo = cardsArray[secondFlippedCardIndex.row];
        
        // Get the two collection view cells that represent cardOne and cardTwo
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell;
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell;
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            //It's a match
            soundPlayer.playSound(effect: .match)
            // Set the status and remove them
            cardOne.isMatched = true;
            cardTwo.isMatched = true;
            
            cardOneCell?.remove();
            cardTwoCell?.remove();
            
            // was that the last pair
            checkForGameEnd();
        }
        else {
            // It's not a match
            soundPlayer.playSound(effect: .noMatch)
            
            cardOne.isFlipped = false;
            cardTwo.isFlipped = false;
            // Flip them back over
            cardOneCell?.flipDown();
            cardTwoCell?.flipDown();
        }
        
        // Reset the firstFlippedCardIndex Property
        firstFlippedCardIndex = nil;
    }
    
    func checkForGameEnd(){
        // check if any of the cards is unmatched
        
        var hasWon: Bool = true;
        
        for card in cardsArray{
            if card.isMatched == false {
                hasWon = false;
                break;
            }
        }
        
        if hasWon {
            // user has won
            showAlert(Title: "Congratulations!", Message: "You've won the game")
            
        } else {
            // user hasn't won yet, check if there is any time
            if milliseconds <= 0{
                showAlert(Title: "Time's Up", Message: "Sorry! Better luck next time!")
            }
        }
        
    }
    
    func showAlert(Title: String, Message: String){
        // Create the alert
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert);
        
        // Add a button for the user to reset the game
        let tryAgainAction = UIAlertAction(title: "try again", style: .default, handler: {
            action -> Void in self.resetApp()
        })
        // Add a button for the user to dismiss the alert
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(tryAgainAction)
        alert.addAction(okAction)
        
        // Show the alert
        present(alert, animated: true, completion: nil)
    }
    
    func resetApp() {
        cardsArray = [Card]();
        cardsArray = model.getCards();
        milliseconds = 20 * 1000;
        soundPlayer.playSound(effect: .shuffle)
        timerLabel.textColor = UIColor.black;
        collectionView.reloadData()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        }
}

