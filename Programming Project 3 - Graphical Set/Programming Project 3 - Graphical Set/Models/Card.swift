//
//  Card.swift
//  Programming Project 3 - Graphical Set
//
//  Created by Souley on 06/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import Foundation

///
/// Represents a Card used in the `SetGame`
///

struct Card {
    
    /// There are 4 different features a card might have. Each feature's value might vary based
    /// on the `Variant` options (color, shape, shade, number).
    init(_ feature1: Variant, _ feature2: Variant, _ feature3: Variant, _ feature4: Variant) {
        self.feature1 = feature1
        self.feature2 = feature2
        self.feature3 = feature3
        self.feature4 = feature4
    }
    
    /// Each feature might contain one of three different variants.
    /// These variants are completely generic and not tied to any specific ones.
    enum Variant: Int {
        case v1 = 1
        case v2 = 2
        case v3 = 3
    }
    
    let feature1: Variant
    let feature2: Variant
    let feature3: Variant
    let feature4: Variant
}

// MARK: - Protocol conformance extensions

extension Card: CustomStringConvertible {
    var description: String {
        return "[\(feature1.rawValue), \(feature2.rawValue), \(feature3.rawValue), \(feature4.rawValue)]"
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return(
            (lhs.feature1 == rhs.feature1) &&
                (lhs.feature2 == rhs.feature2) &&
                (lhs.feature3 == rhs.feature3) &&
                (lhs.feature4 == rhs.feature4)
        )
    }
}

extension Card: Hashable {
    var hashValue: Int {
        return feature1.rawValue ^ feature2.rawValue ^ feature3.rawValue ^ feature4.rawValue
    }
}
