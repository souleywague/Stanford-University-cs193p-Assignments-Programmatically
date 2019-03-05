//
//  SetGame.swift
//  Programming Project 2 - Set
//
//  Created by Souley on 05/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

///
/// Provides the core functionality of a set game (Model)
///

///
/// A 'Set' consists of three cards in which each feature is EITHER the same on each card OR is
/// different on each card. That is to say, any feature in the 'Set' of three cards is either
/// common to all three cards or is different on each card.
///

struct SetGame {
    
    private(set) var score = 0
    
    private(set) var deck = Set<Card>()
    
    private(set) var openCards = Set<Card>()
    
    init() {
        populateDeck()
    }
    
    /// Populate the deck of cards.
    private mutating func populateDeck() {
        for feature1 in 1...3 {
            for feature2 in 1...3 {
                for feature3 in 1...3 {
                    for feature4 in 1...3 {
                        deck.insert(
                            Card(
                                Card.Variant(rawValue: feature1)!,
                                Card.Variant(rawValue: feature2)!,
                                Card.Variant(rawValue: feature3)!,
                                Card.Variant(rawValue: feature4)!
                            )
                        )
                    }
                }
            }
        }
    }
    
    /// Draw `n` number of random cards from the `deck`, and place them into the `openCards` list.
    @discardableResult mutating func draw(n: Int) -> Set<Card> {
        var newCards = Set<Card>()
        
        for _ in 1...n {
            if let newCard = deck.removeRandomElement() {
                newCards.insert(newCard)
            } else {
                break
            }
        }
        
        for card in newCards {
            openCards.insert(card)
        }
        return newCards
    }
    
    /// Draw one random card from the `deck`, and place it into the `openCards` list.
    mutating func draw() -> Card? {
        if let newCard = deck.removeRandomElement() {
            openCards.insert(newCard)
            return newCard
        }
        return nil
    }
    
    /// Evaluate the given cards. Return whether or not they are a valid set.
    mutating func evaluateSet(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        if !openCards.contains(card1) || !openCards.contains(card2) || !openCards.contains(card3) {
            print("evaluateSet() -> Given cards are not in play")
            return false
        }
        
        func evaluate(_ v1: Card.Variant, _ v2: Card.Variant, _ v3: Card.Variant) -> Bool {
            return (v1 == v2 && v1 == v3) || ((v1 != v2) && (v1 != v3) && (v2 != v3))
        }
        
        let feature1 = evaluate(card1.feature1, card2.feature1, card3.feature1)
        let feature2 = evaluate(card1.feature2, card2.feature2, card3.feature2)
        let feature3 = evaluate(card1.feature3, card2.feature3, card3.feature3)
        let feature4 = evaluate(card1.feature4, card2.feature4, card3.feature4)
        
        let isSet = (feature1 && feature2 && feature3 && feature4)
        
        score += (isSet ? Score.validSet : Score.invalidSet)
        
        if isSet {
            if let index = openCards.firstIndex(of: card1) {
                openCards.remove(at: index)
            }
            if let index = openCards.firstIndex(of: card2) {
                openCards.remove(at: index)
            }
            if let index = openCards.firstIndex(of: card3) {
                openCards.remove(at: index)
            }
        }
        return isSet
    }
    
    /// Determines how many points different actions take.
    private struct Score {
        private init() {}
        static let validSet = +3
        static let invalidSet = -5
    }
}

// MARK: - Extensions

extension Set {
    mutating func removeRandomElement() -> Element? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        if self.count > 0 {
            let element = self.remove(at: index)
            return element
        } else {
            return nil
        }
    }
}
