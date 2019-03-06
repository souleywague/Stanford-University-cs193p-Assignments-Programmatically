//
//  CardButton2.swift
//  Programming Project 2 - Set
//
//  Created by Souley on 06/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation
import UIKit

///
/// Represents a UI card button/view to play a Set game
///

class CardButton: UIButton {
    
    var card: Card? {
        didSet {
            if card == nil {
                isHidden = true
                setAttributedTitle(NSAttributedString(), for: .normal)
            } else {
                setAttributedTitle(titleForCard(card!), for: .normal)
                isHidden = false
            }
        }
    }
    
    var cardIsSelected: Bool {
        get {
            return layer.borderColor == #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } set {
            if newValue == true {
                layer.borderWidth = 3.0
                layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            } else {
                layer.borderWidth = 0.0
                layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.cornerRadius = frame.width * 0.2
        layer.borderColor = UIColor.lightGray.cgColor
        isHidden = true
    }
    
    func toggleCardSelection() {
        cardIsSelected = !cardIsSelected
    }
    
    private func titleForCard(_ card: Card) -> NSAttributedString {
        /// Shape
        var symbol: String
        
        switch card.feature1 {
        case .v1: symbol = "▲"
        case .v2: symbol = "●"
        case .v3: symbol = "■"
        }
        
        /// Color
        var color: UIColor
        
        switch card.feature2 {
        case .v1: color = #colorLiteral(red: 0.6733523739, green: 0, blue: 0.8106054687, alpha: 1)
        case .v2: color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .v3: color = #colorLiteral(red: 0.03970472395, green: 0.8106054687, blue: 0, alpha: 1)
        }
        
        /// Shade
        var filled: Bool
        
        switch card.feature3 {
        case .v1: filled = false; color = color.withAlphaComponent(1.0)
        case .v2: filled = true; color = color.withAlphaComponent(0.3)
        case .v3: filled = true; color = color.withAlphaComponent(1.0)
        }
        
        /// Number
        switch card.feature4 {
        case .v1: break
        case .v2: symbol += "" + symbol
        case .v3: symbol += "" + symbol + "" + symbol
        }
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeWidth: 1.0 * (filled ? -1.0 : 5.0),
            NSAttributedString.Key.foregroundColor: color
        ]
        
        let attributedString = NSAttributedString(string: symbol, attributes: attributes)
        
        return attributedString
    }
    
}

