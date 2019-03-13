//
//  SetCardView.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    // MARK: - Card Stack View
    
    weak var cardStackView: SetCardStackView?
    
    // MARK: - Card Properties
    
    var card: SetCard?
    
    var isFaceUp = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var brandNew = true
    var needsToRemoveFromTable = false
    
    var state: CardState = .normal {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    enum CardState {
        case normal, selected, matched, mismatched, hinted
    }
    
    lazy var features: Features = getCardFeatures()
    typealias Features = (
        shape: String, numberOfSymbols: Int, shading: String, color: UIColor
    )
    private func getCardFeatures() -> Features {
        let shape = CardFeatures.Shape.all[card!.symbol]
        let numberOfSymbols = CardFeatures.numberOfSymbols[card!.numberOfSymbols]
        let shading  = CardFeatures.Fill.all[card!.shading]
        let color = CardFeatures.color[card!.color]
        return (shape, numberOfSymbols, shading, color)
    }
    
    // MARK: - Initialization
    
    init(card: SetCard, cardStackView: SetCardStackView, rect: CGRect) {
        super.init(frame: rect)
        
        self.card = card
        self.cardStackView = cardStackView
        
        backgroundColor = UIColor.clear
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Drawing a Card
    
    // main drawing function
    override func draw(_ rect: CGRect) {
        // card background
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        let cardBackgroundColor = isFaceUp ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        cardBackgroundColor.setFill()
        roundedRect.addClip()
        roundedRect.fill()
        alpha = 0.3
        
        if isFaceUp {
            // a colorful border
            drawBorder()
            
            // symbols
            let shape = CardFeatures.Shape(rawValue: features.shape)!
            let rects = getRectsForSymbols()
            for rect in rects {
                draw(shape, in: rect)
            }
        }
    }
    
    /// Setting up a colorful border depending on the `state`.
    private func drawBorder() {
        alpha = 1.0
        layer.cornerRadius = 8.0
        layer.borderWidth = 2.0
        
        switch state {
        case .normal:
            layer.borderColor = CardBorder.normal // UIColor.clear.cgColor
            layer.borderWidth = 0.0
        case .selected:
            layer.borderColor = CardBorder.selected // UIColor.blue.cgColor
        case .matched:
            layer.borderColor = CardBorder.matched // UIColor.green.cgColor
        case .mismatched:
            layer.borderColor = CardBorder.mismatched // UIColor.red.cgColor
        case .hinted:
            layer.borderColor = CardBorder.hinted // UIColor.yellow.cgColor
        }
    }
    
    // if in runtime font size is changing (via Accessebility), we need to redraw
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()   // redraw view's contents (view + subviews)
        setNeedsLayout()    // adjust layout of view's subviews
    }
    
    /// Returns an array of rectangles for all the card symbols. Each rectangle has a proper size and position for further drawing a symbol inside 'self'.
    private func getRectsForSymbols() -> [CGRect] {
        var rects = [CGRect]()
        
        switch features.numberOfSymbols {
        case 1:
            rects.append(rectForOneSymbol(center: bounds.secondThird.center))
        case 2:
            rects.append(rectForOneSymbol(center: bounds.firstHalf.center))
            rects.append(rectForOneSymbol(center: bounds.secondHalf.center))
        case 3:
            rects.append(rectForOneSymbol(center: bounds.firstThird.center))
            rects.append(rectForOneSymbol(center: bounds.secondThird.center))
            rects.append(rectForOneSymbol(center: bounds.thirdThird.center))
        default:
            break
        }
        return rects
    }
    
    /// Returns a rectangle, centered by 'center' point, with proper size for drawing a symbol inside.
    private func rectForOneSymbol(center: CGPoint) -> CGRect {
        var size = CGSize()
        if bounds.width <= bounds.height {
            size.height = bounds.height * SizeRatio.symbolHeightToCardHeightWhenVertical
            size.width = size.height * SizeRatio.symbolWidthToHeight
        } else {
            size.width = bounds.width * SizeRatio.symbolWidthToCardWidthWhenHorizontal
            size.height = size.width / SizeRatio.symbolWidthToHeight
        }
        let origin = center.offsetBy(dx: -size.width/2, dy: -size.height/2)
        return CGRect(origin: origin, size: size)
    }
    
    /// Performs complete drawing of the given shape.
    private func draw(_ shape: CardFeatures.Shape, in rect: CGRect) {
        let path = getPath(of: shape, in: rect)
        
        path.lineWidth = SizeRatio.symbolOutlineWidth
        features.color.setStroke()
        path.stroke()
        
        let shading = CardFeatures.Fill(rawValue: features.shading)!
        switch shading {
        case .none:
            break
        case .stripe:
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            path.addClip()
            let stripes = getPathOfStripes(in: rect)
            stripes.lineWidth = SizeRatio.stripeWidth
            stripes.stroke()
            context.restoreGState()
        case .solid:
            features.color.setFill()
            path.fill()
        }
    }
    
    /// Returns path of one of the 'Card' symbols.
    private func getPath(of shape: CardFeatures.Shape, in rect: CGRect) -> UIBezierPath {
        var path = UIBezierPath()
        
        let origin = rect.origin
        let width = rect.width
        let height = rect.height
        
        switch shape {
        case .diamond:
            path.move(to: origin.offsetBy(dx: 0, dy: height/2))
            path.addLine(to: origin.offsetBy(dx: width/2, dy: 0))
            path.addLine(to: origin.offsetBy(dx: width, dy: height/2))
            path.addLine(to: origin.offsetBy(dx: width/2, dy: height))
            path.close()
            
        case .squiggle:
            path.move(to: origin.offsetBy(dx: 0, dy: height/2))
            path.addQuadCurve(to: origin.offsetBy(dx: width/3, dy: 0),
                              controlPoint: origin)
            path.addCurve(to: origin.offsetBy(dx: width*(5/6), dy: height/8),
                          controlPoint1: origin.offsetBy(dx: width*(4/9), dy: 0),
                          controlPoint2: origin.offsetBy(dx: width*(2/3), dy: height/2))
            path.addCurve(to: origin.offsetBy(dx: width, dy: height/2),
                          controlPoint1: origin.offsetBy(dx: width*(5/6), dy: 0),
                          controlPoint2: origin.offsetBy(dx: width, dy: 0))
            
            path.addQuadCurve(to: origin.offsetBy(dx: width*(2/3), dy: height),
                              controlPoint: origin.offsetBy(dx: width, dy: height))
            path.addCurve(to: origin.offsetBy(dx: width*(1/6), dy: height*(7/8)),
                          controlPoint1: origin.offsetBy(dx: width*(5/9), dy: height),
                          controlPoint2: origin.offsetBy(dx: width/3, dy: height/2))
            path.addCurve(to: origin.offsetBy(dx: 0, dy: height/2),
                          controlPoint1: origin.offsetBy(dx: width*(1/6), dy: height),
                          controlPoint2: origin.offsetBy(dx: 0, dy: height))
            
        case .oval:
            path = UIBezierPath(ovalIn: rect)
        }
        
        return path
    }
    
    /// Returns path for "horizontal striping" effect.
    private func getPathOfStripes(in rect:CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let origin = rect.origin
        var dy: CGFloat = 0
        while dy < rect.height {
            path.move(to: origin.offsetBy(dx: 0, dy: dy))
            path.addLine(to: origin.offsetBy(dx: rect.width, dy: dy))
            dy += SizeRatio.stripeWidth + 1
        }
        return path
    }
}

// MARK: - Constants

extension SetCardView {
    private struct CardFeatures {
        enum Shape: String {
            case diamond, squiggle, oval
            static let all = ["diamond", "squiggle", "oval"]
        }
        enum Fill: String {
            case none, stripe, solid
            static let all = ["none", "stripe", "solid"]
        }
        static let numberOfSymbols = [1, 2, 3]
        static let color = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)] // [UIColor.red, UIColor.green, UIColor.purple]
    }
    private struct CardBorder {
        static let normal: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        static let selected: CGColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        static let matched: CGColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        static let mismatched: CGColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        static let hinted: CGColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
    }
    struct SizeRatio {
        fileprivate static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        fileprivate static let symbolHeightToCardHeightWhenVertical: CGFloat = 0.20
        fileprivate static let symbolWidthToCardWidthWhenHorizontal: CGFloat = 0.28
        fileprivate static let symbolWidthToHeight: CGFloat = 8/5
        fileprivate static let symbolOutlineWidth: CGFloat = 2.0
        fileprivate static let stripeWidth: CGFloat = 0.2
        static let cardWidthToHeightRatio: CGFloat = 5/8
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}
