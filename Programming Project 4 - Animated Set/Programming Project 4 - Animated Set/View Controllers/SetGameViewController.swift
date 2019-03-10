//
//  SetGameViewController.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

///
/// Main view controller for a Set game.
///

class SetGameViewController: UIViewController {
    
    // MARK: - User Interface Properties
    
    private lazy var boardView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        
        label.text? = "Score: \(game.score)"
        
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.layer.cornerRadius = .pi
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dealButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Deal", for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        button.setTitleColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var newGameButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("New Game", for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        button.setTitleColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - SetGame Properties
    
    private var game: SetGame!
    
    private lazy var board: [SetCard:SetCardView] = [:]
    
    private let initialCards = 9
    
    private var selectedCards: [SetCard] {
        var result = [SetCard]()
        for (card, cardView) in board {
            if cardView.isSelected {
                result.append(card)
            }
        }
        return result
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        setupActionsAndGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    // MARK: - Actions
    
    @objc private func dealButtonTapped() {
        cleanUpBoard()
        game.draw(n: 3)
        updateUI()
    }
    
    @objc private func newGameButtonTapped() {
        newGame()
    }
    
    @objc private func tapCard(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        
        guard let cardView = recognizer.view as? SetCardView else { return }
        
        cardView.isSelected = !cardView.isSelected
        
        processBoard()
    }
    
    @objc private func swipeDownToDealCard(_ recognizer: UISwipeGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        
        dealButtonTapped()
    }
    
    @objc private func rotationToReshuffleCardGesture(_ recognizer: UIRotationGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        cleanUpBoard()
        game.shuffleOpenCards()
        // TODO: Implement the UI update after game.openCards is shuffled.
    }
    
    // MARK: - SetGame Functions
    
    private func newGame() {
        boardView.subviews.forEach { $0.removeFromSuperview() }
        board = [:]
        game = SetGame()
        game.draw(n: initialCards)
        updateUI()
    }
    
    private func updateUI() {
        updateScoreLabel()
        updateBoard()
        updateBoardView()
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func updateBoard() {
        for card in game.openCards {
            if board[card] == nil {
                board[card] = getCardView(for: card)
            }
        }
    }
    
    private func updateBoardView() {
        guard let grid = gridForCurrentBoard() else { return }
        
        for (i, card) in board.enumerated() {
            if let cardFrame = grid[i] {
                
                let cardView = card.value
                
                let margin = min(cardFrame.width, cardFrame.height) * 0.05
                cardView.frame = cardFrame.insetBy(dx: margin, dy: margin)
                
                if !boardView.subviews.contains(cardView) {
                    boardView.addSubview(cardView)
                }
            }
        }
    }
    
    private func gridForCurrentBoard() -> Grid? {
        let (rows, columns) = getRowsAndColumns(numberOfCards: board.count)
        
        guard rows > 0, columns > 0 else { return nil }
        
        return Grid(layout: .dimensions(rowCount: rows, columnCount: columns), frame: boardView.bounds)
    }
    
    private func getCardView(for card: SetCard) -> SetCardView {
        let cardView = SetCardView(frame: CGRect())
        
        switch card.feature1 {
        case .v1: cardView.color = .red
        case .v2: cardView.color = .purple
        case .v3: cardView.color = .green
        }
        
        switch card.feature2 {
        case .v1: cardView.shade = .solid
        case .v2: cardView.shade = .shaded
        case .v3: cardView.shade = .unfilled
        }
        
        switch card.feature3 {
        case .v1: cardView.shape = .oval
        case .v2: cardView.shape = .diamond
        case .v3: cardView.shape = .squiggle
        }
        
        switch card.feature4 {
        case .v1: cardView.elements = .one
        case .v2: cardView.elements = .two
        case .v3: cardView.elements = .three
        }
        
        addGestureRecognizers(cardView)
        
        return cardView
    }
    
    private func processBoard() {
        cleanUpBoard()
        
        if selectedCards.count == 3 {
            let isSet = game.evaluateSet(selectedCards[0], selectedCards[1], selectedCards[2])
            
            if isSet {
                match(selectedCards)
            } else {
                mismatch(selectedCards)
            }
            updateUI()
        }
    }
    
    private func cleanUpBoard() {
        for (card, cardView) in board {
            if !game.openCards.contains(card) {
                board.removeValue(forKey: card)
                cardView.removeFromSuperview()
                updateUI()
            }
            cardView.cardState = .regular
        }
    }
    
    private func match(_ cards: [SetCard]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = .matched
            }
        }
    }
    
    private func mismatch(_ cards: [SetCard]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = .mismatched
            }
        }
    }
    
    private func getRowsAndColumns(numberOfCards: Int) -> (rows: Int, columns: Int) {
        if numberOfCards <= 0 {
            return (0, 0)
        }
        
        var rows = Int(sqrt(Double(numberOfCards)))
        
        if (rows * rows) < numberOfCards {
            rows += 1
        }
        
        var columns = rows
        
        if (rows * (columns - 1)) >= numberOfCards {
            columns -= 1
        }
        
        return (rows, columns)
    }
    
    private func addGestureRecognizers(_ cardView: SetCardView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        cardView.addGestureRecognizer(tapRecognizer)
    }
    
    private func addSwipeGestureRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownToDealCard(_:)))
        
        swipeRecognizer.direction = .down
        
        boardView.addGestureRecognizer(swipeRecognizer)
    }
    
    private func addRotationGestureRecognizer() {
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationToReshuffleCardGesture(_:)))
        
        rotationGesture.rotation = 3
        
        boardView.addGestureRecognizer(rotationGesture)
    }
    
    // MARK: - Setup Functions
    
    private func setupActionsAndGestures() {
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        dealButton.addTarget(self, action: #selector(dealButtonTapped), for: .touchUpInside)
        addSwipeGestureRecognizer()
        addRotationGestureRecognizer()
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(boardView)
        view.addSubview(bottomStackView)
        
        boardView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        boardView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        boardView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5).isActive = true
        boardView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.90).isActive = true
        
        bottomStackView.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 10).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        bottomStackView.addArrangedSubview(newGameButton)
        bottomStackView.addArrangedSubview(scoreLabel)
        bottomStackView.addArrangedSubview(dealButton)
    }
}

// MARK: - CardView Extension

fileprivate extension SetCardView {
    enum CardState {
        case regular, matched, mismatched
    }
    
    var cardState: CardState {
        get {
            if layer.borderColor == #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor {
                return .mismatched
            } else if layer.borderColor == #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor {
                return .matched
            } else {
                return .regular
            }
        } set {
            switch newValue {
            case .regular:
                layer.borderWidth = 0.0
                layer.borderColor = UIColor.clear.cgColor
            case .matched:
                layer.borderWidth = bounds.width * 0.1
                layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
            case .mismatched:
                layer.borderWidth = bounds.width * 0.1
                layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor
            }
        }
    }
}
