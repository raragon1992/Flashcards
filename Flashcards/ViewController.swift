//
//  ViewController.swift
//  Flashcards
//
//  Created by Ryan Aragon on 10/13/18.
//  Copyright © 2018 Ryan Aragon. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!

    
    //Array to hold flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    
    func animateCardOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: {finished in
            
            
            // updates labels
            self.updateLabels()
            
            self.animateCardIn()})
        
    }
    
    func animateCardIn () {
        
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity
        })
        
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Read saved flashcards
        readSavedFlashcards()
        
        if flashcards.count == 0 {
        
        updateFlashcard(question: "Whats the Capital of Idaho", answer: "Boise")
        }
        else {
            updateLabels()
            updateNextPrevButtons()
        }
    }

    

    @IBAction func didTapOnPrev(_ sender: Any) {
        // Decrease current Index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        
        
        //Update buttons
        updateNextPrevButtons()
        
        animateCardIn()
    }
    
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // Increase current Index
        currentIndex = currentIndex + 1
        
        //Update labels
        updateLabels()
        
        
        //Update buttons
        updateNextPrevButtons()
        animateCardOut()
    }
    

    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        flipFlashcard()
    }
    
    func flipFlashcard(){
        frontLabel.isHidden = true
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
        self.frontLabel.isHidden = true})
    }
    
    func updateFlashcard(question: String, answer: String){
        
        let flashcard = Flashcard(question: question, answer: answer)

        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        
        //Adds flashcards to Flashcard array
        flashcards.append(flashcard)
        
        //Logging to the console
        print("Added new Flashcard")
        print("We now have \(flashcards.count) flashcards")
        
        //Update current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        //Update buttons
        updateNextPrevButtons()
        
        //Update Labels
        updateLabels()
        
 
    }
    func updateNextPrevButtons() {
        
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        }
        else {
            nextButton.isEnabled = true
        }
        
        //Disable prev button if at beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        }
        else {
            prevButton.isEnabled = true
        }
        
        
    }
    
    func updateLabels() {
        
        //Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        
    }
    
    func saveAllFlashcardsToDisk() {
        
        //From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        //Save array on disk using userdefaults
        UserDefaults.standard.set(flashcards, forKey: "flashcards")
        
        //Log it
        print("Flashcard saved to user default")
    }
    
    func readSavedFlashcards() {
        
        // Read dictionary from disk
       if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]] {
            
            //dictionary array
        let savedCards = dictionaryArray.map {dictionary -> Flashcard in
            return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
        }
            //Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
            
            
            
        }
            
        }
        
        
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }


}


