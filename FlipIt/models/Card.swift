//
//  Card.swift
//  FlipIt
//
//  Created by theapache64 on 08/04/18.
//  Copyright © 2018 theapache64. All rights reserved.
//

import Foundation

public class Card{
    var emoji : String
    var isFlipped : Bool
    
    init(emoji : String, isFlipped : Bool){
        self.emoji = emoji
        self.isFlipped = isFlipped
    }
}
