//
//  CardView.swift
//  Programming Project 3 - Graphical Set
//
//  Created by Souley on 06/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class CardView: UIView {

    // MARK: - Card Type
    
    enum Color: Int {
        case green, red, purple
    }
    
    enum Shade {
        case solid, shaded, unfilled
    }
    
    enum Elements {
        case one, two, three
    }
    
    enum Shape {
        case squiggle, diamond, oval
    }
    
    // MARK: - Card Properties
    
    var color: Color? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var shade: Shade? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var elements: Elements? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var shape: Shape? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    } 
    
    // MARK: - Overriden Properties
    
    override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Overriden Functions
    
    override func draw(_ rect: CGRect) {
        setupCard()
        
        guard color != nil, shade != nil, elements != nil, shape != nil else {
            print("All features must be set. Cannot draw card.")
            return
        }
        
        for rect in getRects(for: elements!) {
            drawContent(rect: rect, shape: shape!, color: color!, shade: shade!)
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
    
    // MARK: - Private Properties
    
    private let shapeMargin: CGFloat = 0.15

    // MARK: - Private Methods
    
    private func initialSetup() {
        isOpaque = false
    }
    
    /// Drawing a card with all its properties.
    
    private func setupCard() {
        let cornerRadius = min(bounds.size.width, bounds.size.height) * 0.1
        
        let cardPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        cardPath.addClip()
        
        UIColor.white.setFill()
        
        if isSelected {
            cardPath.lineWidth = min(bounds.size.width, bounds.size.height) * 0.1
            #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).setStroke()
        } else {
            cardPath.lineWidth = min(bounds.size.width, bounds.size.height) * 0.1
            UIColor.lightGray.setStroke()
        }
        
        cardPath.fill()
        cardPath.stroke()
    }
    
    private func path(forShape shape: Shape, in rect: CGRect) -> UIBezierPath {
        switch shape {
        case .diamond:
            return diamondPath(in: rect)
        case .oval:
            return ovalPath(in: rect)
        case .squiggle:
            return squigglePath(in: rect)
        }
    }
    
    private func strokeColor(for color: Color) -> UIColor {
        switch color {
        case .green:
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.6377331317, green: 0, blue: 0.7568627596, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    private func fillColor(for color: Color, with shade: Shade) -> UIColor {
        let stroke = strokeColor(for: color)
        
        switch shade {
        case .solid:
            return stroke.withAlphaComponent(1.0)
        case .shaded:
            return stroke.withAlphaComponent(0.2)
        case .unfilled:
            return stroke.withAlphaComponent(0.0)
        }
    }
    
    private func drawContent(rect: CGRect, shape: Shape, color: Color, shade: Shade) {
        let shapePath = path(forShape: shape, in: rect)
        
        let stroke = strokeColor(for: color)
        
        let fill = fillColor(for: color, with: shade)
        
        stroke.setStroke()
        fill.setFill()
        
        shapePath.lineWidth = min(rect.size.width, rect.size.height) * 0.05
        
        shapePath.fill()
        shapePath.stroke()
    }
    
    /// Rects for number of elements on a card.
    
    private func getRects(for elements: Elements) -> [CGRect] {
        let maxOfWidthAndHeight = max(bounds.size.width, bounds.size.height)
        let sizeOfEachRect = CGSize(width: maxOfWidthAndHeight/3, height: maxOfWidthAndHeight/3)
        
        var rects = [CGRect]()
        
        switch elements {
        case .one:
            rects.append(rectForOneElement(sizeOfEachRect: sizeOfEachRect))
        case .two:
            rects += rectForTwoElements(sizeOfEachRect: sizeOfEachRect)
        case .three:
            rects += rectsForThreeElements(sizeOfEachRect: sizeOfEachRect)
        }
        return rects
    }
    
    private func rectForOneElement(sizeOfEachRect: CGSize) -> CGRect {
        let x = bounds.midX - sizeOfEachRect.width / 2
        let y = bounds.midY - sizeOfEachRect.height / 2
        
        let originPoint = CGPoint(x: x, y: y)
        
        return CGRect(origin: originPoint, size: sizeOfEachRect)
    }
    
    private func rectForTwoElements(sizeOfEachRect: CGSize) -> [CGRect] {
        let rectForOne = rectForOneElement(sizeOfEachRect: sizeOfEachRect)
        
        let rect1, rect2: CGRect
        
        if bounds.width > bounds.height {
            rect1 = rectForOne.offsetBy(dx: sizeOfEachRect.width/2, dy: 0)
            rect2 = rectForOne.offsetBy(dx: -(sizeOfEachRect.width/2), dy: 0)
        } else {
            rect1 = rectForOne.offsetBy(dx: 0, dy: sizeOfEachRect.height/2)
            rect2 = rectForOne.offsetBy(dx: 0, dy: -(sizeOfEachRect.height/2))
        }
        return [rect1, rect2]
    }
    
    private func rectsForThreeElements(sizeOfEachRect: CGSize) -> [CGRect] {
        let centerRect = rectForOneElement(sizeOfEachRect: sizeOfEachRect)
        
        let rect1, rect2: CGRect
        
        if bounds.width > bounds.height {
            rect1 = CGRect(x: centerRect.minX - sizeOfEachRect.width,
                           y: centerRect.minY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
            
            rect2 = CGRect(x: centerRect.maxX,
                           y: centerRect.minY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
        } else {
            rect1 = CGRect(x: centerRect.minX,
                           y: centerRect.minY - sizeOfEachRect.height,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
            
            rect2 = CGRect(x: centerRect.minX,
                           y: centerRect.maxY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
        }
        return [centerRect, rect1, rect2]
    }
    
    /// UIBezierPath for shapes that fits inside a given rect. The paths contains margin spaces.
    
    private func diamondPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let margin = min(rect.size.width, rect.size.height) * shapeMargin
        
        let topCenter = CGPoint(x: rect.midX, y: rect.minY + margin)
        path.move(to: topCenter)
        
        let centerRight = CGPoint(x: rect.maxX - margin, y: rect.midY)
        path.addLine(to: centerRight)
        
        let bottomCenter = CGPoint(x: rect.midX, y: rect.maxY - margin)
        path.addLine(to: bottomCenter)
        
        let centerLeft = CGPoint(x: rect.minX + margin, y: rect.midY)
        path.addLine(to: centerLeft)
        
        path.close()
        
        return path
    }
    
    private func ovalPath(in rect: CGRect) -> UIBezierPath {
        let margin = min(rect.size.width, rect.size.height) * shapeMargin
        
        let rectWithMargin = CGRect(x: rect.origin.x + margin,
                                    y: rect.origin.y + margin,
                                    width: rect.size.width - (margin * 2),
                                    height: rect.size.height - (margin * 2))
        
        return UIBezierPath(ovalIn: rectWithMargin)
    }
    
    private func squigglePath(in rect: CGRect) -> UIBezierPath {
        let margin = min(rect.size.width, rect.size.height) * shapeMargin
        let drawingRect = rect.insetBy(dx: margin, dy: margin)
        
        let path = UIBezierPath()
        var point, cp1, cp2: CGPoint
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.05, y: drawingRect.origin.y + drawingRect.size.height*0.40)
        path.move(to: point)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.35, y: drawingRect.origin.y + drawingRect.size.height*0.25)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.09, y: drawingRect.origin.y + drawingRect.size.height*0.15)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.18, y: drawingRect.origin.y + drawingRect.size.height*0.10)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.75, y: drawingRect.origin.y + drawingRect.size.height*0.30)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.40, y: drawingRect.origin.y + drawingRect.size.height*0.30)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.60, y: drawingRect.origin.y + drawingRect.size.height*0.45)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.97, y: drawingRect.origin.y + drawingRect.size.height*0.35)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.87, y: drawingRect.origin.y + drawingRect.size.height*0.15)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.98, y: drawingRect.origin.y + drawingRect.size.height*0.00)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.45, y: drawingRect.origin.y + drawingRect.size.height*0.85)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.95, y: drawingRect.origin.y + drawingRect.size.height*1.10)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.50, y: drawingRect.origin.y + drawingRect.size.height*0.95)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.25, y: drawingRect.origin.y + drawingRect.size.height*0.85)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.40, y: drawingRect.origin.y + drawingRect.size.height*0.80)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.35, y: drawingRect.origin.y + drawingRect.size.height*0.75)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.05, y: drawingRect.origin.y + drawingRect.size.height*0.40)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.00, y: drawingRect.origin.y + drawingRect.size.height*1.10)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.005, y: drawingRect.origin.y + drawingRect.size.height*0.60)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        return path
    }
}
