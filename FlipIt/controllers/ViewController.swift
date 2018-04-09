//
//  ViewController.swift
//  FlipIt
//
//  Created by theapache64 on 07/04/18.
//  Copyright © 2018 theapache64. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var flipCount = 0 {
        didSet{lblFlipCount.text = "\(flipCount)"
        }
    }
    
    
    var firstCard : (Card, UIButton)?
    var secondCard : (Card, UIButton)?
    
    
    var cards = [Card]()
    
    @IBOutlet var vCardsHolder: UIView!
    @IBOutlet var lblFlipCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looping through card
        for case let card as UIButton in vCardsHolder.subviews {
            //Setting click listener
            card.addTarget(self,action: #selector(onCardClicked),for: .touchUpInside)
        }
        
        cards = try! CardUtils.getRandomCards(count : vCardsHolder.subviews.count)
        
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
                    
                    
                }else{
                    
                    //No match flip it out
                    firstCard?.1.setTitle("", for: .normal)
                    secondCard?.1.setTitle("", for: .normal)
                    
                    firstCard?.0.isFlipped = false
                    secondCard?.0.isFlipped = false
                    
                    secondCard = nil
                }
                
                card.isFlipped = true
                cardButton.setTitle(card.emoji, for: .normal)
                
                firstCard = (card,cardButton)
            }
            
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

