//
//  Utilities.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 12/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

// MARK: - Int

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

// MARK: - CGFloat

extension CGFloat {
    var arc4random: CGFloat {
        switch self {
        case 1...CGFloat.greatestFiniteMagnitude:
            return CGFloat(arc4random_uniform(UInt32(self)))
        case -CGFloat.greatestFiniteMagnitude..<0:
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        default:
            return 0
        }
    }
}

// MARK: - CGRect

extension CGRect {
    var firstHalf: CGRect {
        if width <= height {
            return CGRect(x: minX, y: minY, width: width, height: height/2)
        } else {
            return CGRect(x: minX, y: minY, width: width/2, height: height)
        }
    }
    var secondHalf: CGRect {
        if width <= height {
            return CGRect(x: minX, y: midY, width: width, height: height/2)
        } else {
            return CGRect(x: midX, y: minY, width: width/2, height: height)
        }
    }
    var firstThird: CGRect {
        if width <= height {
            return CGRect(x: minX, y: minY, width: width, height: height/3)
        } else {
            return CGRect(x: minX, y: minY, width: width/3, height: height)
        }
    }
    var secondThird: CGRect {
        if width <= height {
            return CGRect(x: minX, y: maxY/3, width: width, height: height/3)
        } else {
            return CGRect(x: maxX/3, y: minY, width: width/3, height: height)
        }
    }
    var thirdThird: CGRect {
        if width <= height {
            return CGRect(x: minX, y: maxY*2/3, width: width, height: height/3)
        } else {
            return CGRect(x: maxX*2/3, y: minY, width: width/3, height: height)
        }
    }
    
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    func withCenter(_ center: CGPoint) -> CGRect {
        return CGRect(origin: center.offsetBy(dx: -midX, dy: -midY), size: size)
    }
}

// MARK: - CGPoint

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy )
    }
}

// MARK: - CGSize

extension CGSize {
    var area: CGFloat {
        return width * height
    }
}

// MARK: - Collection

extension Collection {
    // returns the one and only element of the Collection
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

// MARK: - UIViewController

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
