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
            bResetCards.isHidden = flipCount == 0
        }
    }
    
    let normalCardBg = hexStringToUIColor(hex: "#E0E0E0")
    let activeCardBg = hexStringToUIColor(hex: "#BDBDBD")
    
    var matchesHappend = 0
    
    var firstCard : (Card, UIButton)?
    var secondCard : (Card, UIButton)?
    
    
    var cards = [Card]()
    
    @IBOutlet var vCardsHolder: UIView!
    @IBOutlet var lblFlipCount: UILabel!
    
    @IBOutlet var bResetCards: UIButton!
    
    var pointSound  : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting reset button hidden at first
        
        
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
    
    private static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func onExitButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Exit?", message: "Are you sure about this?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            exit(0)
        }))
        alert.addAction(UIAlertAction(title : "Cancel", style: .default,handler : nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func resetGame(){
        cards = try! CardUtils.getRandomCards(count : vCardsHolder.subviews.count)
        
        for case let card as UIButton in vCardsHolder.subviews {
            //Setting click listener
            card.isHidden = false
            card.setTitle("", for: .normal)
            card.backgroundColor = normalCardBg
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
            
            UIView.animate(withDuration: 0.2, animations: {
                cardButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    cardButton.transform = CGAffineTransform.identity
                })
            })
            
            flipCount += 1
            
            if(firstCard==nil){
                
                card.isFlipped = true
                cardButton.setTitle(card.emoji, for: .normal)
                cardButton.backgroundColor = activeCardBg
                
                
                firstCard = (card,cardButton)
                return
            }
            
            if(secondCard==nil){
                card.isFlipped = true
                cardButton.setTitle(card.emoji, for: .normal)
                cardButton.backgroundColor = activeCardBg
                
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
                    
                    firstCard?.1.backgroundColor = normalCardBg
                    secondCard?.1.backgroundColor = normalCardBg
                    
                    firstCard?.0.isFlipped = false
                    secondCard?.0.isFlipped = false
                    
                    secondCard = nil
                    
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                
                card.isFlipped = true
                cardButton.setTitle(card.emoji, for: .normal)
                cardButton.backgroundColor = activeCardBg
                
                firstCard = (card,cardButton)
            }
            
        }
        
      
        
        if (matchesHappend + 2) == cards.count {
            
         
            
            //Game finished
            let alert = UIAlertController(title: "Congratulations", message: "You've succesfully finished the game with \(flipCount) flips", preferredStyle: .alert)
            
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

