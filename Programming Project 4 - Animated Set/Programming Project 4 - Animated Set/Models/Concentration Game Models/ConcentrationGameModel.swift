//
//  ConcentrationGameModel.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

///
/// Models a "Concentration" game
///

class Concentration {
    
    private(set) var cards = [ConcentrationCard]()
    
    private(set) var flipCount = 0
    private(set) var score = 0
    
    private(set) var startChooseCardTimeLaps: Date?
    private(set) var endChooseCardTimeLaps: Date?
    
    private var indexOfOneAndOnlyFacedUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        } set {
            for index in cards.indices {
                if(cards[index].isFaceUp) {
                    if !cards[index].isMatched && cards[index].hasBeenFlippedAtLeastOne {
                        score -= 1
                    }
                    cards[index].hasBeenFlippedAtLeastOne = true
                }
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1 ... numberOfPairsOfCards {
            let card = ConcentrationCard()
            
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFacedUpCard, matchIndex != index {
                startChooseCardTimeLaps = Date()
                if cards[matchIndex].identifier == cards[index].identifier {
                    endChooseCardTimeLaps = Date()
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    updateScore()
                }
                cards[index].isFaceUp = true
            }  else {
                indexOfOneAndOnlyFacedUpCard = index
            }
        }
    }
    
    private func updateScore() {
        if endChooseCardTimeLaps! < startChooseCardTimeLaps! + 2 {
            score += 4
        } else {
            score += 2
        }
    }
    
    deinit {
        flipCount = 0
        score = 0
    }
}


// MARK: - Extensions

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
