//
//  SetCardStackView.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 12/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class SetCardStackView: UIView, UIDynamicAnimatorDelegate {
    
    var newCardsStartFrom: CGRect!
    var discardedCardsGoTo: CGRect!
    
    var grid: Grid {
        return Grid(frame: bounds,
                    cellCount: oldCardsToRearrange.count + newCardsToDeal.count,
                    aspectRatio: SetCardView.SizeRatio.cardWidthToHeightRatio)
    }
    
    var cardViews: [SetCardView] {
        return subviews.filter { $0 is SetCardView } as! [SetCardView]
    }
    
    var newCardsToDeal: [SetCardView] {
        return cardViews.filter { $0.brandNew && !$0.needsToRemoveFromTable }
    }
    
    var oldCardsToRearrange: [SetCardView] {
        return cardViews.filter { !$0.brandNew && !$0.needsToRemoveFromTable }
    }
    
    var cardsToRemoveFromTable: [SetCardView] {
        return cardViews.filter { $0.needsToRemoveFromTable }
    }
    
    var matchedCards: [SetCardView] {
        return cardViews.filter { $0.state == .matched }
    }
    
    func addCardView(with card: SetCard) {
        guard subviews.count < SetGame.SetGameConstants.maxNumberOfCardsInDeck else { return }
        guard getCardView(with: card) == nil else { return }
        
        let cardView = SetCardView(card: card, cardStackView: self, rect: newCardsStartFrom)
        addSubview(cardView)
    }
    
    func getCardView(with card: SetCard) -> SetCardView? {
        return cardViews.filter { $0.card == card }.first
    }
    
    func setCardViewState(_ state: SetCardView.CardState, for card: SetCard) {
        if let cardView = getCardView(with: card) {
            cardView.state = state
        }
    }
}
