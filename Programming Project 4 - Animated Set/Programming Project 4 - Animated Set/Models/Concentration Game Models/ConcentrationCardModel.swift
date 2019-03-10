//
//  ConcentrationCardModel.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

///
/// This model represents a "Card" that is used in the "Concentration" game
///

struct ConcentrationCard {
    
    var isFaceUp = false
    var isMatched = false
    var hasBeenFlippedAtLeastOne = false
    
    let identifier: Int
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
}
