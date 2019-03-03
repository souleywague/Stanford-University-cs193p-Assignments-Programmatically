//
//  ConcentrationGameModel.swift
//  Programming Project 1 - Concentration
//
//  Created by Souley on 03/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

/// Models a "Concentration" game
///
/// Concentration, also known as Match Match, Match Up, Memory, or simply Pairs, is a card game
/// in which all of the cards are laid face down on a surface and two cards are flipped face up
/// over each turn. The object of the game is to turn over pairs of matching cards.
/// Concentration can be played with any number of players or as solitaire. It is a particularly
/// good game for young children, though adults may find it challenging and stimulating as well.
///

class Concentration {
    
    var cards = [Card]()
    
    var flipCount = 0
    
    var score = 0
    
    var indexOfOneAndOnlyFacedUpCard: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFacedUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFacedUpCard = nil
            }  else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFacedUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1 ... numberOfPairsOfCards {
            let card = Card()
            
            cards += [card, card]
        }
        cards.shuffle()
    }
}
