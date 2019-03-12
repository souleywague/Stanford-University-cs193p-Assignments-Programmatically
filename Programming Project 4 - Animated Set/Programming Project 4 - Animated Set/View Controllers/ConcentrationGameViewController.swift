//
//  ConcentrationGameViewController.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

///
/// Main view controller for a Concentration Game.
///

class ConcentrationGameViewController: UIViewController {
    
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
            
            button.titleLabel?.font = .systemFont(ofSize: 50)
            
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
    
    // MARK: - Concentration Game Properties
    
    private var game: Concentration!
    
    lazy var theme: Theme = defaultTheme
    
    private var defaultTheme = Theme(name: "Default", boardColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), cardColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),
                                     emojis: ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🚚","🚛","🚜"])
    
    private var emoji = [ConcentrationCard: String]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(newGameButtonTapped))
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLayout()
        setupButtons()
    }
    
    // MARK: - Actions
    
    @objc private func touchCard(_ sender: UIButton) {
        UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateUIFromModel()
        } else {
            print("Warning! The chosen card was not in CardButtons")
        }
    }
    
    @objc func newGameButtonTapped() {
        initialSetup()
    }
    
    // MARK: - Concentration Game Functions
    
    private func initialSetup() {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
        
        navigationItem.title = theme.name
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = theme.boardColor
        
        mapCardsToEmojis()
        
        updateUIFromModel()
    }
    
    // MARK: - Setup Functions
    
    private func updateUIFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flip: \(game.flipCount)"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
            }
        }
    }
    
    private func mapCardsToEmojis() {
        var emojis = theme.emojis
        
        emojis.shuffle()
        
        for card in game.cards {
            if !emojis.isEmpty, emoji[card] != nil {
                emoji[card] = emojis.removeFirst()
            } else {
                emoji[card] = "?"
            }
        }
    }
    
    private func emoji(for card: ConcentrationCard) -> String {
        return emoji[card] ?? "?"
    }
    
    // MARK: - Setup Functions
    
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
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topStackView)
        topStackView.addSubview(flipCountLabel)
        topStackView.addSubview(scoreLabel)
        topStackView.addSubview(concentrationStackView)
        
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
        concentrationStackView.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: -5).isActive = true
        
        horizontalStackViews.forEach { stackView in
            concentrationStackView.addArrangedSubview(stackView)
        }
    }
    
}

// MARK: - Protocol Conformance Extensions

extension ConcentrationGameViewController: ThemeChooserDelegate {
    func didChooseTheme(_ theme: Theme) {
        self.theme = theme
        initialSetup()
    }
}

