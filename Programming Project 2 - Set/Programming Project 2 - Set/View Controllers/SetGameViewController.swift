//
//  SetViewController.swift
//  Programming Project 2 - Set
//
//  Created by Souley on 05/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    // MARK: - User Interface Properties
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var setGameStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var horizontalStackViews: [UIStackView] = {
        var stackViews = [UIStackView]()
        
        for _ in 0..<8 {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackViews.append(stackView)
        }
        return stackViews
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var cardButtons: [CardButton] = {
        var buttons = [CardButton]()
        
        for _ in 0..<24 {
            let button = CardButton()
            
            button.titleLabel?.font = .systemFont(ofSize: 40)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            buttons.append(button)
        }
        return buttons
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
    
    private var selectedCards: [Card] {
        var cards = [Card]()
        
        for cardButton in cardButtons {
            if cardButton.cardIsSelected {
                if let card = cardButton.card {
                    cards.append(card)
                }
            }
        }
        return cards
    }
    
    private let initialCards = 12
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        initialSetup()
    }
    
    // MARK: - Actions
    
    @objc private func dealButtonTapped() {
        let replacedCards = cleanUp()
        
        if replacedCards > 0 {
            print("Not dealing because cleanup already \(replacedCards) cards.")
            return
        }
        
        let maxCardsToDeal = 3
        var dealtCards = 0
        
        for cardButton in cardButtons {
            if dealtCards == maxCardsToDeal {
                return
            }
            if cardButton.card == nil {
                if let newCard = game.draw() {
                    cardButton.card = newCard
                    dealtCards += 1
                }
            }
        }
    }
    
    @objc private func touchCard(_ sender: CardButton) {
        cleanUp()
        
        sender.toggleCardSelection()
        
        if selectedCards.count == 3 {
            let isSet = game.evaluateSet(selectedCards[0], selectedCards[1], selectedCards[2])
            if isSet {
                match(selectedCards)
            } else {
                mismatch(selectedCards)
            }
        }
        updateScoreLabel()
    }
    
    @objc private func newGameButtonTapped() {
        initialSetup()
    }
    
    // MARK: - SetGame Functions
    
    private func match(_ cards: [Card]) {
        for card in cards {
            if let cardButton = getButton(for: card) {
                cardButton.cardIsSelected = false
                cardButton.backgroundColor = CardColor.match
            }
        }
    }
    
    private func mismatch(_ cards: [Card]) {
        for card in cards {
            if let cardButton = getButton(for: card) {
                cardButton.cardIsSelected = false
                cardButton.backgroundColor = CardColor.mismatch
            }
        }
    }
    
    private func getButton(for card: Card) -> CardButton? {
        for cardButton in cardButtons {
            if cardButton.card == card {
                return cardButton
            }
        }
        return nil
    }
    
    private func replaceCardButtonOrHideIt(in cardButton: CardButton) {
        if let newCard = game.draw() {
            cardButton.card = newCard
        } else {
            print("No cards in deck to replace, hiding card button.")
            cardButton.card = nil
        }
    }
    
    @discardableResult private func cleanUp() -> Int {
        var cardsReplaced = 0
        
        for cardButton in cardButtons {
            cardButton.backgroundColor = CardColor.defaultColor
            
            if cardButton.card != nil {
                if !game.openCards.contains(cardButton.card!) {
                    replaceCardButtonOrHideIt(in: cardButton)
                    cardsReplaced += 1
                }
            }
        }
        return cardsReplaced
    }
    
    // MARK: - Setup Functions
    
    private func initialSetup() {
        for cardButton in cardButtons {
            cardButton.card = nil
            cardButton.cardIsSelected = false
            cardButton.backgroundColor = CardColor.defaultColor
        }
        
        game = SetGame()
        game.draw(n: initialCards)
        
        updateScoreLabel()
        
        for (i, card) in game.openCards.enumerated() {
            cardButtons[i].card = card
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func setupButtons() {
        for button in cardButtons {
            button.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
        }
        
        cardButtons[0...2].forEach { button in
            horizontalStackViews[0].addArrangedSubview(button)
        }
        
        cardButtons[3...5].forEach { button in
            horizontalStackViews[1].addArrangedSubview(button)
        }
        
        cardButtons[6...8].forEach { button in
            horizontalStackViews[2].addArrangedSubview(button)
        }
        
        cardButtons[9...11].forEach { button in
            horizontalStackViews[3].addArrangedSubview(button)
        }
        
        cardButtons[12...14].forEach { button in
            horizontalStackViews[4].addArrangedSubview(button)
        }
        
        cardButtons[15...17].forEach { button in
            horizontalStackViews[5].addArrangedSubview(button)
        }
        
        cardButtons[18...20].forEach { button in
            horizontalStackViews[6].addArrangedSubview(button)
        }
        
        cardButtons[21...23].forEach { button in
            horizontalStackViews[7].addArrangedSubview(button)
        }
        
        dealButton.addTarget(self, action: #selector(dealButtonTapped), for: .touchUpInside)
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topStackView)
        topStackView.addSubview(setGameStackView)
        topStackView.addSubview(bottomStackView)
        
        topStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        topStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        setGameStackView.topAnchor.constraint(equalTo: topStackView.topAnchor, constant: 10).isActive = true
        setGameStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 5).isActive = true
        setGameStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -5).isActive = true
        setGameStackView.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.90).isActive = true
        
        horizontalStackViews.forEach { stackView in
            setGameStackView.addArrangedSubview(stackView)
        }
        
        bottomStackView.topAnchor.constraint(equalTo: setGameStackView.bottomAnchor, constant: 10).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 10).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -10).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true
        
        bottomStackView.addArrangedSubview(newGameButton)
        bottomStackView.addArrangedSubview(scoreLabel)
        bottomStackView.addArrangedSubview(dealButton)

        setupButtons()
    }
    
}
