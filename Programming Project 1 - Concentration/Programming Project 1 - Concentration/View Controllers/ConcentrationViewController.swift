//
//  ConcentrationViewController.swift
//  Programming Project 1 - Concentration
//
//  Created by Souley on 03/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    // MARK: - User Interface Properties
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var horizontalStackViews: [UIStackView] = {
        var stackViews = [UIStackView]()
        
        for _ in 0..<5 {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            stackViews.append(stackView)
        }
        return stackViews
    }()
    
    private lazy var cardButtons: [UIButton] = {
    var buttons = [UIButton]()
        
        for _ in 0..<20 {
            let button = UIButton()
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            buttons.append(button)
        }
        return buttons
    }()
    
    private lazy var flipCountLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Flips: \(game.flipCount)"
        
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Score: \(game.score)"
        
        return label
    }()
    
    // MARK: - Concentration Game Properties
    
    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
    
    private lazy var emojiChoices = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷"]
    
    private var emoji = [Int: String]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        setupLayout()
    }
    
    // MARK: - Actions
    
    @objc private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            updateFlipCountLabel()
        } else {
            print("Warning! The chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            }
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            
            emoji[card.identifier] = emojiChoices[randomIndex]
            
            emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    // MARK: - Setup Functions
    
    private func updateFlipCountLabel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(verticalStackView)
        view.addSubview(flipCountLabel)
 
        flipCountLabel.bottomAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        flipCountLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        flipCountLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5).isActive = true
        
        verticalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5).isActive = true
        
        horizontalStackViews.forEach { stackView in
            verticalStackView.addArrangedSubview(stackView)
        }
        
        setupCardButtons()
        updateViewFromModel()
    }
    
    private func setupCardButtons() {
        for button in cardButtons {
            button.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
        }
        
        cardButtons[0...3].forEach { button in
            horizontalStackViews[0].addArrangedSubview(button)
        }
        
        cardButtons[4...7].forEach { button in
            horizontalStackViews[1].addArrangedSubview(button)
        }
        
        cardButtons[8...11].forEach { button in
            horizontalStackViews[2].addArrangedSubview(button)
        }
        
        cardButtons[12...15].forEach { button in
            horizontalStackViews[3].addArrangedSubview(button)
        }
        
        cardButtons[16...19].forEach { button in
            horizontalStackViews[4].addArrangedSubview(button)
        }
    }

}

