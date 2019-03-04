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
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var concentrationStackView: UIStackView = {
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
            
            stackViews.append(stackView)
        }
        return stackViews
    }()
    
    private lazy var cardButtons: [UIButton] = {
        var buttons = [UIButton]()
        
        for _ in 0..<20 {
            let button = UIButton()
            
            button.titleLabel?.font = .systemFont(ofSize: 40)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            buttons.append(button)
        }
        return buttons
    }()
    
    private lazy var flipCountLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 25)
        
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Flips: \(game.flipCount)"
        
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 25)
        
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Score: \(game.score)"
        
        return label
    }()
    
    private lazy var newGameButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("New Game", for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Concentration Game Properties
    
    private lazy var game: Concentration! = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
    
    private lazy var animalTheme = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷"]
    
    private lazy var sportTheme = ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🥅","🏒","🥊"]
    
    private lazy var facesTheme = ["😀","😅","😇","😍","😋","🤪","🧐","😎","🤩","😭","🤬","😱","🤮"]
    
    private lazy var clothesTheme = ["🧥","👚","👕","👖","👔","👗","👙","👘","👠","🧤","👑","🎒","🌂"]
    
    private lazy var foodTheme = ["🍏","🍐","🍋","🍌","🍉","🍇","🥥","🍆","🍑","🥑","🥩","🥟","🍕"]
    
    private lazy var carsTheme = ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🚚","🚛","🚜"]
    
    private lazy var emojiThemes = [animalTheme, sportTheme, facesTheme, clothesTheme, foodTheme, carsTheme]
    
    private lazy var emojiChoices = chooseRandomTheme(from: emojiThemes)
    
    private lazy var cardBackgroundColor = setupButtonBackgroundColor()
    
    private lazy var emoji = [Int: String]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Actions
    
    @objc private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            updateFlipCountAndScoreLabel()
        } else {
            print("Warning! The chosen card was not in cardButtons")
        }
    }
    
    @objc func newGameButtonTapped() {
        game = nil
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
        emojiChoices = chooseRandomTheme(from: emojiThemes)
        cardBackgroundColor = setupButtonBackgroundColor()
        setupLayout()
        updateFlipCountAndScoreLabel()
    }
    
    // MARK: - Setup Functions
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackgroundColor
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
    
    private func chooseRandomTheme(from themes: [[String]]) -> [String] {
        return themes.randomElement()!
    }
    
    private func updateFlipCountAndScoreLabel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func setupViewBackgroundColor() {
        switch emojiChoices {
        case animalTheme:
            view.backgroundColor = #colorLiteral(red: 1, green: 0.2993363322, blue: 0.6630111634, alpha: 1)
        case sportTheme:
            view.backgroundColor = #colorLiteral(red: 1, green: 0.5937196917, blue: 0.08242634248, alpha: 1)
        case facesTheme:
            view.backgroundColor = #colorLiteral(red: 0.1428158921, green: 0.3664214567, blue: 1, alpha: 1)
        case clothesTheme:
            view.backgroundColor = #colorLiteral(red: 0.04062543526, green: 0.9449648283, blue: 1, alpha: 1)
        case foodTheme:
            view.backgroundColor = #colorLiteral(red: 0.6541963498, green: 1, blue: 0.1064179282, alpha: 1)
        case carsTheme:
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default:
            break
        }
    }
    
    private func setupButtonBackgroundColor() -> UIColor? {
        var choosenColor: UIColor?
        switch emojiChoices {
        case animalTheme:
            choosenColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case sportTheme:
            choosenColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case facesTheme:
            choosenColor = #colorLiteral(red: 0.9686274529, green: 0.8058855335, blue: 0.1210624714, alpha: 1)
        case clothesTheme:
            choosenColor = #colorLiteral(red: 0.9686274529, green: 0.06510510622, blue: 0.07257949882, alpha: 1)
        case foodTheme:
            choosenColor = #colorLiteral(red: 0.5072839704, green: 0.1115098435, blue: 0.8549019694, alpha: 1)
        case carsTheme:
            choosenColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        default:
            break
        }
        return choosenColor
    }
    
    private func setupButtons() {
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
        
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topStackView)
        topStackView.addSubview(flipCountLabel)
        topStackView.addSubview(scoreLabel)
        topStackView.addSubview(concentrationStackView)
        topStackView.addSubview(newGameButton)

        topStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        topStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        flipCountLabel.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
        flipCountLabel.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 5).isActive = true
        flipCountLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scoreLabel.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -5).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        concentrationStackView.topAnchor.constraint(equalTo: flipCountLabel.bottomAnchor, constant: 5).isActive = true
        concentrationStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 5).isActive = true
        concentrationStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -5).isActive = true
        concentrationStackView.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.65).isActive = true
        
        horizontalStackViews.forEach { stackView in
            concentrationStackView.addArrangedSubview(stackView)
        }
        
        newGameButton.topAnchor.constraint(equalTo: concentrationStackView.bottomAnchor, constant: 20).isActive = true
        newGameButton.centerXAnchor.constraint(equalTo: topStackView.centerXAnchor).isActive = true
        newGameButton.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0.25).isActive = true
        
        setupButtons()
        updateViewFromModel()
        setupViewBackgroundColor()
    }

}

