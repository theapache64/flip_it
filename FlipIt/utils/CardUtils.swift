//
//  CardUtils.swift
//  FlipIt
//
//  Created by theapache64 on 08/04/18.
//  Copyright © 2018 theapache64. All rights reserved.
//

import Foundation

class CardUtils{
    
    
    enum CardException : Error {
        case onMoreCardOrdered(String)
    }
    
    private static var emojiEngine : Array<String> = [
        "😈",
        "👻",
        "💀",
        "☠️",
        "😻",
        "🧢",
        "🕶",
        "🎒",
        "🍭",
        "⚽️",
        "☎️",
        "💣",
        "🎈",
        "🐙",
        "💡",
        "💰"
    ]
    
    public static func  getRandomCards(count : Int) throws -> Array<Card> {
        
        //Getting number of pairs
        let numOfPairs = count / 2
        
        
        if (numOfPairs <= emojiEngine.count){
            
            //Acceptable pair
            
            //Shuffling engine
            emojiEngine.shuffle()
            
            //Getting first pair
            var newEmojis : Array<String> = [String](emojiEngine[0..<numOfPairs])
            
            //Copying same pair
            newEmojis += newEmojis
            
            //Shuffling
            newEmojis.shuffle()
            
            //Converting to card
            var cards = [Card]()
            for newEmoji in newEmojis{
                cards.append(Card(emoji : newEmoji, isFlipped : false))
            }
            
            return cards
            
        }else{
            throw CardException.onMoreCardOrdered("You can't order more card than engine has : \(count)")
        }
        
    }
}

private extension Array {
    mutating func shuffle(){
        var temp = [Element]()
        for _ in self{
            //Generating random number
            let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
            //Take the element
            let element = self[Int(randomIndex)]
            //Put element
            temp.append(element)
            //Remove it
            self.remove(at : randomIndex)
        }
        
        self = temp
    }
}
