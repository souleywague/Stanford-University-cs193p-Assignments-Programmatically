//
//  SetCardBehavior.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 12/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class SetCardBehavior: UIDynamicBehavior {
    
    // MARK: - Adding Behavior
    
    /// Allows collisions.
    private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        // referenceView's edges (cardView's edges) will become a boundary of behavior
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    /// Other behavior settings.
    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.2   // if > 1.0 it starts to gain speed
        behavior.resistance = 0
        return behavior
    }()
    
    /// Rearranges old cards on table and animates new ones.
    func updateCardsOnTable(in setCardStackView: SetCardStackView) {
        let delay = setCardStackView.cardsToRemoveFromTable.isEmpty ? 0.0 :
            Delays.rearrange
        
        // add rotation
        setCardStackView.oldCardsToRearrange.forEach { setCardView in
            spin(setCardView, duration: Durations.rearrange * 6/3, delay: delay, direction: .counterclockwise)
        }
        
        // rearrange cards
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Durations.rearrange,
            delay: delay,
            options: [],
            animations: {
                for (index, cardView) in setCardStackView.oldCardsToRearrange.enumerated() {
                    cardView.center = setCardStackView.grid[index]!.center
                    cardView.bounds.size = setCardStackView.grid[index]!.size
                }
        },
            completion: animateNewCards(in: setCardStackView, delay: delay)
        )
    }
    
    /// Moves new cards from the deck to its new position on table,
    /// then flips it over.
    private func animateNewCards(in setCardStackView: SetCardStackView, delay: TimeInterval) -> ((UIViewAnimatingPosition) -> Void) {
        return { if $0 == .end {
            let duration = Durations.deal
            var delay = delay
            var index = setCardStackView.oldCardsToRearrange.count
            
            for cardView in setCardStackView.newCardsToDeal {
                // add rotation
                self.spin(cardView, duration: duration / 2, delay: delay, direction: .clockwise)
                self.spin(cardView, duration: duration / 2, delay: delay + duration / 2, direction: .clockwise)
                
                // move and flip over
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: duration,
                    delay: delay,
                    options: [],
                    animations: {
                        cardView.center = setCardStackView.grid[index]!.center
                        cardView.bounds.size = setCardStackView.grid[index]!.size
                        cardView.alpha = 1.0
                        cardView.brandNew = false
                },
                    completion: self.flipOver(cardView)
                )
                delay += 0.2
                index += 1
            }
            }}
    }
    
    /// Flips card over.
    func flipOver(_ cardView: SetCardView) -> ((UIViewAnimatingPosition) -> Void) {
        return { if $0 == .end {
            UIView.transition(
                with: cardView,
                duration: Durations.flipOver,
                options: [.transitionFlipFromLeft],
                animations: { cardView.isFaceUp = !cardView.isFaceUp },
                completion: { finished in
                    if cardView.needsToRemoveFromTable {
                        self.removeCardView(cardView)
                        cardView.removeFromSuperview()
                    }
            }
            )
            }}
    }
    
    private enum SpinDirection {
        case clockwise, counterclockwise
    }
    
    /// Spins card by 360 (3x120).
    private func spin(_ cardView: SetCardView, duration: TimeInterval, delay: TimeInterval, direction: SpinDirection) {
        let angle = (direction == .clockwise) ? (CGFloat.pi * 2/3) : (-CGFloat.pi * 2/3)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration / 3,
            delay: delay,
            options: [],
            animations: { cardView.transform = cardView.transform.rotated(by: angle) },
            completion: { if $0 == .end {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: duration / 3,
                    delay: 0,
                    options: [],
                    animations: { cardView.transform = cardView.transform.rotated(by: angle) },
                    completion: { if $0 == .end {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: duration / 3,
                            delay: 0,
                            options: [],
                            animations: { cardView.transform = cardView.transform.rotated(by: angle) },
                            completion: nil
                        )
                        }}
                )
                }}
        )
    }
    
    /// Makes item bouncing around.
    func bounceAround(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    /// Pushes our item in the same direction it was collided.
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        
        // calculating angle of pushing
        push.angle = CGFloat.pi.arc4random
        
        // setting up a force
        let magnitude: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 20
        push.magnitude = 1.0 + magnitude.arc4random
        
        // applying push once then removing it from behavior
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    var snapBehaviors: [UISnapBehavior: SetCardView] = [:]
    
    /// Snaps our card to the discard pile.
    func snapToDiscardedPile(_ setCardView: SetCardView) {
        collisionBehavior.removeItem(setCardView)
        
        // move card to discard pile
        let discardedDeck = setCardView.cardStackView!.discardedCardsGoTo!
        let snap = UISnapBehavior(item: setCardView, snapTo: discardedDeck.center)
        snap.damping = 1.9
        addChildBehavior(snap)
        snapBehaviors[snap] = setCardView
        
        // change cards size to discard pile's size
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Durations.snapMatched,
            delay: 0,
            options: [],
            animations: { setCardView.bounds.size = discardedDeck.size },
            completion: nil
        )
    }
    
    // MARK: - Removing Behavior
    
    /// Removes any behavior affected on item.
    func removeCardView(_ setCardView: SetCardView) {
        itemBehavior.removeItem(setCardView)
        collisionBehavior.removeItem(setCardView)
        snapBehaviors.keys.forEach { snap in
            if snapBehaviors[snap] == setCardView {
                snapBehaviors.removeValue(forKey: snap)
                removeChildBehavior(snap)
            }
        }
    }
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

// MARK: - Constants

extension SetCardBehavior {
    private struct Durations {
        static let deal: TimeInterval = 0.6
        static let rearrange: TimeInterval = 0.6
        static let flipOver: TimeInterval = 0.5
        static let snapMatched: TimeInterval = 0.5
    }
    private struct Delays {
        static let rearrange: TimeInterval = 1.7
    }
}
