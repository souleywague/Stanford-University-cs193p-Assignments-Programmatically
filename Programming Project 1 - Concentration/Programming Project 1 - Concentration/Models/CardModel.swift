//
//  CardModel.swift
//  Programming Project 1 - Concentration
//
//  Created by Souley on 03/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

///
/// This model represents a "Card" that is used in the "Concentration" game
///

struct Card {
    
    var isFaceUp = false
    
    var isMatched = false
    
    var identifier: Int
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
}
