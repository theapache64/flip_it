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
        var card = cards[cardIndex!]
        
        if(!card.isFlipped){
            
            print(card)
            
            print("Card index:  \(cardIndex!)")
            
            card.isFlipped = true
            
            cardButton.setTitle(card.emoji, for: .normal)
            cardButton.backgroundColor = UIColor.darkGray
            
            //Incrementing flip count
            flipCount += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

