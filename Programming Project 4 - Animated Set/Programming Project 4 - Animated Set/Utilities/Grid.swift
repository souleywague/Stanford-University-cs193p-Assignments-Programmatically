//
//  Grid.swift
//
//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
//
//  Arranges the space in a rectangle into a grid of cells.
//  All cells will be exactly the same size.
//  If the grid does not fill the provided frame edge-to-edge
//    then it will center the grid of cells in the provided frame.
//  If you want spacing between cells in the grid, simply inset each cell's frame.
//
//  How it lays the cells out is determined by the layout property:
//  Layout can be done by (a) fixing the cell size
//    (Grid will create as many rows and columns as will fit)
//  Or (b) fixing the number of rows and columns
//    (Grid will make the cells as large as possible)
//  Or (c) ensuring a certain aspect ratio (width vs. height) for each cell
//    (Grid will make cellCount cells fit, making the cells as large as possible)
//    (you must set the cellCount var for the aspectRatio layout to know what to do)
//
//  The bounding rectangle of a cell in the grid is obtained by subscript (e.g. grid[11] or grid[1,5]).
//  The dimensions tuple will contain the number of (calculated or specified) rows and columns.
//  Setting aspectRatio, dimensions or cellSize, may change the layout.
//
//  To use, simply employ the initializer to choose a layout strategy and set the frame.
//  After creating a Grid, you can change the frame or layout strategy at any time
//    (all other properties will immediately update).

import UIKit

// utility to position card views inside the card stack view

struct Grid {
    
    // MARK: - Public Properties
    
    var frame: CGRect { didSet { recalculate() } }
    var cellCount: Int { didSet { recalculate() } }
    var aspectRatio: CGFloat { didSet { recalculate() } }
    
    // MARK: - Initialization
    
    init(frame: CGRect = CGRect.zero, cellCount: Int ,aspectRatio: CGFloat) {
        precondition(cellCount > 0 && aspectRatio > 0, "Grid.init: 'cellCount' and 'aspectRatio' must be positive numbers.")
        
        self.frame = frame
        self.cellCount = cellCount
        self.aspectRatio = aspectRatio
        recalculate()
    }
    
    // MARK: - Grid Space Management
    
    subscript(row: Int, column: Int) -> CGRect? {
        return self[row * dimensions.columnCount + column]
    }
    subscript(index: Int) -> CGRect? {
        return index < cellFrames.count ? cellFrames[index] : nil
    }
    
    var cellSize: CGSize {
        get { return cellFrames.first?.size ?? CGSize.zero }
    }
    private(set) var dimensions: (rowCount: Int, columnCount: Int) = (0, 0)
    
    private var cellFrames = [CGRect]()
    
    /// Calculates 'cellSize', 'dimensions' and updates 'cellFrames'.
    private mutating func recalculate() {
        let cellSize = largestCellSizeThatFitsAspectRatio()
        
        dimensions.columnCount = Int(frame.size.width / (cellSize.width + Grid.spaceBetweenTwoCells))
        dimensions.rowCount = (cellCount + dimensions.columnCount - 1) / dimensions.columnCount
        
        updateCellFrames(to: cellSize)
    }
    
    /// Based on 'cellCount', 'cellSize' and 'dimensions', calculates frame for each cell and puts it in 'cellFrames'.
    private mutating func updateCellFrames(to cellSize: CGSize) {
        
        // setting up starting point
        let offset = (
            dx: (frame.size.width - CGFloat(dimensions.columnCount) * (cellSize.width + Grid.spaceBetweenTwoCells)) / 2 + Grid.spaceBetweenTwoCells / 2,
            dy: (frame.size.height - CGFloat(dimensions.rowCount) * (cellSize.height + Grid.spaceBetweenTwoCells)) / 2 + Grid.spaceBetweenTwoCells / 2
        )
        var origin = frame.origin
        origin.x += offset.dx
        origin.y += offset.dy
        
        // updating cell frames
        cellFrames.removeAll()
        
        for _ in 0..<cellCount {
            cellFrames.append(CGRect(origin: origin, size: cellSize))
            origin.x += cellSize.width + Grid.spaceBetweenTwoCells
            
            if round(origin.x) > round(frame.maxX - cellSize.width - Grid.spaceBetweenTwoCells / 2) {
                // go to next row
                origin.x = frame.origin.x + offset.dx
                origin.y += cellSize.height + Grid.spaceBetweenTwoCells
            }
        }
    }
    
    private func largestCellSizeThatFitsAspectRatio() -> CGSize {
        var largestSoFar = CGSize.zero
        
        for rowCount in 1...cellCount {
            largestSoFar = cellSizeAssuming(rowCount: rowCount, minimumAllowedSize: largestSoFar)
        }
        for columnCount in 1...cellCount {
            largestSoFar = cellSizeAssuming(columnCount: columnCount, minimumAllowedSize: largestSoFar)
        }
        return largestSoFar
    }
    
    private func cellSizeAssuming(rowCount: Int? = nil, columnCount: Int? = nil, minimumAllowedSize: CGSize = CGSize.zero) -> CGSize {
        
        var size = CGSize.zero
        if let columnCount = columnCount {
            size.width = frame.size.width / CGFloat(columnCount) - Grid.spaceBetweenTwoCells
            size.height = size.width / aspectRatio
        } else if let rowCount = rowCount {
            size.height = frame.size.height / CGFloat(rowCount) - Grid.spaceBetweenTwoCells
            size.width = size.height * aspectRatio
        }
        
        if size.area > minimumAllowedSize.area {
            if Int(frame.size.height / (size.height + Grid.spaceBetweenTwoCells)) * Int(frame.size.width / (size.width + Grid.spaceBetweenTwoCells)) >= cellCount {
                return size
            }
        }
        return minimumAllowedSize
    }
}

// MARK: - Constants

extension Grid {
    static let spaceBetweenTwoCells: CGFloat = 16.0
}


