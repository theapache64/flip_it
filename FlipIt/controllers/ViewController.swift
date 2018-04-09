//
//  ViewController.swift
//  FlipIt
//
//  Created by theapache64 on 07/04/18.
//  Copyright © 2018 theapache64. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices
import AVFoundation


class ViewController: UIViewController {
    
    var flipCount = 0 {
        didSet{lblFlipCount.text = "\(flipCount)"
        }
    }
    
    var matchesHappend = 0
    
    var firstCard : (Card, UIButton)?
    var secondCard : (Card, UIButton)?
    
    
    var cards = [Card]()
    
    @IBOutlet var vCardsHolder: UIView!
    @IBOutlet var lblFlipCount: UILabel!
    
    var pointSound  : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looping through card
        for case let card as UIButton in vCardsHolder.subviews {
            //Setting click listener
            card.addTarget(self,action: #selector(onCardClicked),for: .touchUpInside)
        }
        
        cards = try! CardUtils.getRandomCards(count : vCardsHolder.subviews.count)
        do{
            let soundUrl = Bundle.main.url(forResource: "points", withExtension: "wav")
            pointSound = try AVAudioPlayer(contentsOf: soundUrl!)
            pointSound?.prepareToPlay()
        }catch let error {
            print(error)
        }
        
    }
    
    @IBAction func onResetGameClicked(_ button : UIButton) {
        resetGame()
    }
    
    private func resetGame(){
        cards = try! CardUtils.getRandomCards(count : vCardsHolder.subviews.count)
        
        for case let card as UIButton in vCardsHolder.subviews {
            //Setting click listener
            card.isHidden = false
            card.setTitle("", for: .normal)
        }
        
        firstCard = nil
        secondCard = nil
        
        flipCount = 0
        matchesHappend = 0
    }
    
    
    @objc func onCardClicked(cardButton: UIButton!){
        
        //Card clicked
        let cardIndex = vCardsHolder.subviews.index(of: cardButton)
        let card = cards[cardIndex!]
        
    
        
        if(!card.isFlipped){
            
            flipCount += 1
            
            if(firstCard==nil){
                
                card.isFlipped = true
                cardButton.setTitle(card.emoji, for: .normal)
                
                firstCard = (card,cardButton)
                return
            }
            
            if(secondCard==nil){
                card.isFlipped = true
                cardButton.setTitle(card.emoji, for: .normal)
                
                secondCard = (card,cardButton)
                return
            }
            
            if(firstCard != nil && secondCard != nil){
                
                //Match or hide
                if(firstCard?.0.emoji==secondCard?.0.emoji){
                    
                    //Match
                    firstCard?.1.isHidden = true
                    secondCard?.1.isHidden = true
                    
                    firstCard = nil
                    secondCard = nil
                    
                    matchesHappend += 2
                    pointSound?.play()

                    
        
                }else{
                    
                    //No match flip it out
                    firstCard?.1.setTitle("", for: .normal)
                    secondCard?.1.setTitle("", for: .normal)
                    
                    firstCard?.0.isFlipped = false
                    secondCard?.0.isFlipped = false
                    
                    secondCard = nil
                    
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                
                card.isFlipped = true
                cardButton.setTitle(card.emoji, for: .normal)
                
                firstCard = (card,cardButton)
            }
            
        }
        
      
        
        if (matchesHappend + 2) == cards.count {
            
         
            
            //Game finished
            let alert = UIAlertController(title: "Congratulations", message: "You've succesfully finished the game with \(flipCount) flips. Do you want to try again ?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
            
            resetGame()
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

