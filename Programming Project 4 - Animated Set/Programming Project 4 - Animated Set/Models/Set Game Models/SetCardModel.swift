//
//  SetCardModel.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

///
/// Represents a Card used in the `SetGame`
///

struct SetCard {
    
    // MARK: - Public Properties
    
    let numberOfSymbols: Int
    let symbol: Int
    let shading: Int
    let color: Int
    
    var description: String {
        return "Card(numberOfSymbols: \(numberOfSymbols), symbol: \(symbol), shading: \(shading), color: \(color))"
    }
    
    // MARK: - Card Features
    
    private typealias Features = (numberOfSymbols: Int, symbol: Int, shading: Int, color: Int)
    
    private static var featuresFactory = [Features]()
    
    // Builds an array of "Features" filled with unique tuples of random values in the given range
    private static func makeFeaturesFactory() {
        let range = SetCard.featuresRange
        
        for numberOfSymbols in range {
            for symbol in range {
                for shading in range {
                    for color in range {
                        featuresFactory.append((numberOfSymbols, symbol, shading, color))
                    }
                }
            }
        }
    }
    
    private static func getFeatures() -> Features {
        if featuresFactory.isEmpty {
            makeFeaturesFactory()
        }
        return featuresFactory.removeLast()
    }
    
    // MARK: - Initialization
    
    init() {
        (numberOfSymbols, symbol, shading, color) = SetCard.getFeatures()
    }
}

// MARK: - Protocol Conformance Extensions

extension SetCard: Equatable {
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return  lhs.numberOfSymbols == rhs.numberOfSymbols &&
            lhs.symbol == rhs.symbol &&
            lhs.shading == rhs.shading &&
            lhs.color == rhs.color
    }
}

// MARK: - Extensions

extension SetCard {
    private static let featuresRange = 0...2
}
