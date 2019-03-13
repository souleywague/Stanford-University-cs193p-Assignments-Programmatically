//
//  SetGameModel.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
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
    
    // MARK: - Private Properties
    
    private(set) var cardsInDeck = [SetCard]()
    private(set) var cardsOnTable = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private(set) var hintedCards = [SetCard]()
    
    private(set) var currentTurn = DateInterval(start: Date(), end: Date())
    private(set) var score = 0
    
    // MARK: - Basic Actions
    
    mutating func deal(numberOfCards: Int) {
        precondition(numberOfCards > 0, "Game.deal(numberOfCards: \(numberOfCards)), number of cards must be > 0")
        
        // Penalty for using "deal 3 cards" option when you can form a "Set"
        if numberOfCards == SetGameConstants.numberOfCardsInSet, let _ = formSet(from: cardsOnTable) {
            addPoints(for: .dealThreeCards)
            selectedCards.removeAll()
        }
        
        // Deal cards
        for _ in 1...numberOfCards {
            if !cardsInDeck.isEmpty {
                cardsOnTable.append(cardsInDeck.removeFirst())
            }
        }
    }
    
    /// Removes selecte cards from the table and put it right to the matched cards.
    private mutating func moveFromSelectedToMatched(cards: [SetCard]) {
        matchedCards.removeAll()
        for card in cards {
            if let index = cardsOnTable.index(of: card) {
                matchedCards.append(cardsOnTable.remove(at: index))
            }
        }
        selectedCards.removeAll()
    }
    
    enum CardsPlacement {
        case inDeck, onTable
    }
    
    /// Shuffles all cards in `cardsInDeck`.
    mutating func shuffleCards(_ placement: CardsPlacement) {
        if placement == .onTable {
            guard selectedCards.count != SetGameConstants.numberOfCardsInSet else { return }
        }
        
        var cardsToShuffle = (placement == .inDeck ? cardsInDeck : cardsOnTable)
        guard !cardsToShuffle.isEmpty else { return }
        
        var shuffledCards = [SetCard]()
        for _ in 1...cardsToShuffle.count {
            let randomCard = cardsToShuffle.remove(at: cardsToShuffle.count.arc4random)
            shuffledCards.append(randomCard)
        }
        
        switch placement {
        case .inDeck: cardsInDeck = shuffledCards
        case .onTable: cardsOnTable = shuffledCards
        }
        selectedCards.removeAll()
    }
    
    /// Performs a "selection/deselection" of cards, changing `score` according to game rules.
    ///
    /// Precondition: `card` must be from the `cardsOnTable`
    mutating func select(card: SetCard) {
        precondition(cardsOnTable.contains(card), "Game.select(card: \(card)), chosen card is not on the table")
        
        // Clear selection after previously not matched "Set"
        if selectedCards.count == SetGameConstants.numberOfCardsInSet {
            selectedCards.removeAll()
        }
        
        // Select/deselect a card
        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.index(of: card)!)
            addPoints(for: .deselection)
        } else {
            selectedCards.append(card)
        }
        
        // Check for "Set"
        if selectedCards.count == SetGameConstants.numberOfCardsInSet {
            if canFormSet(from: selectedCards) {
                // Remove matched "Set" and deal a new one
                moveFromSelectedToMatched(cards: selectedCards)
                
                for _ in 1...SetGameConstants.numberOfCardsInSet {
                    deal(numberOfCards: 1)
                }
                addPoints(for: .selectionMatched)
            } else {
                // "Set" didnt match
                addPoints(for: .selectionDidNotMatch)
            }
        }
    }
    
    private enum CardAction {
        case deselection, dealThreeCards, selectionMatched, selectionDidNotMatch, hint
    }
    
    /// Changes `score` of the current player depending on the action:
    /// * `deselection` (-1)
    /// * `dealThreeCards` (-1)
    /// * `selectionMatched` (+3 / +1) \*
    /// * `selectionDidNotMatch` (-5)
    /// * `hint` (-1)
    ///
    /// \* (+1) If current turn is longer than a 3 seconds.
    private mutating func addPoints(for action: CardAction) {
        switch action {
        case .deselection:
            score += SetGamePoints.deselection
        case .dealThreeCards:
            score += SetGamePoints.dealThreeCards
        case .hint:
            score += SetGamePoints.hint
        case .selectionDidNotMatch:
            currentTurn.end = Date()
            score += SetGamePoints.didNotMatch
        case .selectionMatched:
            currentTurn.end = Date()
            score += currentTurn.duration < SetGameConstants.timeLimitForMatchMax ?
                SetGamePoints.matchMax : SetGamePoints.matchMin
        }
    }
    
    /// Returns three random matching `cards`, taken from the given cards, that form a "Set";
    /// if there is no "Set" available in the given cards, returns nil.
    ///
    /// Precondition: `cards.count` >= `GameConstants.minNumberOfCardsInSet`
    func formSet(from cards: [SetCard]) -> [SetCard]? {
        precondition(cards.count >= SetGameConstants.numberOfCardsInSet, "Game.formSet(from cards: \(cards)). There must be at least three cards to from a set.")
        
        for card1 in cards {
            for card2 in cards {
                for card3 in cards {
                    if card1 != card2 && card1 != card3 && card2 != card3 {
                        if canFormSet(from: [card1, card2, card3]) {
                            return [card1, card2, card3]
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /// Returns a Boolean value indicating whether the given `cards` form a "Set".
    ///
    /// Precondition: `cards.count` == `GameConstants.minNumberOfCardsInSet`
    func canFormSet(from cards: [SetCard]) -> Bool {
        precondition(cards.count == SetGameConstants.numberOfCardsInSet, "Game.canFormSet(from cards: \(cards). There must be exactly three cards to check.")
        
        let card1 = cards[0], card2 = cards[1], card3 = cards[2]
        
        let numberOfSymbols = (card1.numberOfSymbols == card2.numberOfSymbols) && (card1.numberOfSymbols == card3.numberOfSymbols)
        let symbols = (card1.symbol == card2.symbol) && (card1.symbol == card3.symbol)
        let shading = (card1.shading == card2.shading) && (card1.shading == card3.shading)
        let color = (card1.color == card2.color) && (card1.color == card3.color)
        
        return numberOfSymbols || symbols || shading || color
    }
    
    /// Adds three random matching cards on the table to `hintedCards`, if there is any.
    mutating func addHint() {
        if cardsOnTable.count >= SetGameConstants.numberOfCardsInSet, let cards = formSet(from: cardsOnTable) {
            selectedCards.removeAll()
            hintedCards.append(contentsOf: cards)
            addPoints(for: .hint)
        }
    }
    
    mutating func removeHint() {
        hintedCards.removeAll()
    }
    
    // MARK: - Initizalization
    
    /// Creates a shuffled deck of cards.
    ///
    /// Precondition: `numberOfCards` >= `GameConstants.numberOfCardsFirstDeal`
    init(numberOfCards: Int) {
        precondition(numberOfCards >= SetGameConstants.numberOfCardsFirstDeal, "Game.init(numberOfCards: \(numberOfCards)), number of cards must be >= \(SetGameConstants.numberOfCardsFirstDeal)")
        
        for _ in 1...numberOfCards {
            cardsInDeck.append(SetCard())
        }
        shuffleCards(.inDeck)
    }
}

// MARK: - Extensions

extension SetGame {
    struct SetGameConstants {
        static let maxNumberOfCardsInDeck = 81
        static let numberOfCardsFirstDeal = 12
        static let numberOfCardsInSet = 3
        static let standardTurnLength: TimeInterval = 5.0
        static let bonusTime: TimeInterval = 3.0
        static let timeLimitForMatchMax: TimeInterval = 3.0
    }
    struct SetGamePoints {
        static let deselection = -1
        static let dealThreeCards = -1
        static let hint = -1
        static let didNotMatch = -5
        static let matchMax = 3
        static let matchMin = 1
    }
}
