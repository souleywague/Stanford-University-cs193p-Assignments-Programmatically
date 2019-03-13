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
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var setCardStackView: SetCardStackView = {
        let setCardStackView = SetCardStackView()
        
        setCardStackView.backgroundColor = #colorLiteral(red: 0.9070902034, green: 0.9070902034, blue: 0.9070902034, alpha: 1)
        
        setCardStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return setCardStackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        stackView.backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var newSetCardsPileButton: UIButton = {
        let newSetCardsPileButton = UIButton()
        
        newSetCardsPileButton.layer.cornerRadius = 5.0
        newSetCardsPileButton.layer.borderWidth = 2.0
        
        newSetCardsPileButton.translatesAutoresizingMaskIntoConstraints = false
        
        return newSetCardsPileButton
    }()
    
    private lazy var discardSetCardsPileButton: UIButton = {
        let discardSetCardsPileButton = UIButton()
        
        discardSetCardsPileButton.layer.cornerRadius = 5.0
        discardSetCardsPileButton.layer.borderWidth = 2.0
        discardSetCardsPileButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        discardSetCardsPileButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        discardSetCardsPileButton.translatesAutoresizingMaskIntoConstraints = false
        
        return discardSetCardsPileButton
    }()
    
    private lazy var newGameButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Start Game", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.layer.cornerRadius = 5.0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var dealThreeCardsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Deal", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        button.layer.cornerRadius = 5.0
        
        button.isEnabled = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var hintButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Hint", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.layer.cornerRadius = 5.0
        
        button.isEnabled = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 25)
        
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Score: \(game.score)"
        
        return label
    }()
    
    // MARK: - Set Game Properties
    
    private var game = SetGame(numberOfCards: SetGame.SetGameConstants.maxNumberOfCardsInDeck)
    
    private weak var timer: Timer?
    
    // MARK: SetCard Animation
    
    lazy var animator = UIDynamicAnimator(referenceView: setCardStackView)
    lazy var cardBehavior = SetCardBehavior(in: animator)
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.delegate = setCardStackView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLayout()
        setupActionsAndGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCardStackView.newCardsStartFrom = setCardStackView.convert(newSetCardsPileButton.frame,
                                                                      from: newSetCardsPileButton.superview)
        
        setCardStackView.discardedCardsGoTo = setCardStackView.convert(discardSetCardsPileButton.frame,
                                                                       from: discardSetCardsPileButton.superview)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard !game.cardsOnTable.isEmpty else { return }
        
        coordinator.animate(alongsideTransition: nil) { (finished) in
            self.cardBehavior.updateCardsOnTable(in: self.setCardStackView)
        }
    }
    
    // MARK: - Actions
    
    @objc private func startGame(_ sender: UIButton) {
        view.bringSubviewToFront(setCardStackView)
        setCardStackView.cardViews.forEach { $0.removeFromSuperview() }
        
        game = SetGame(numberOfCards: SetGame.SetGameConstants.maxNumberOfCardsInDeck)
        game.deal(numberOfCards: SetGame.SetGameConstants.numberOfCardsFirstDeal)
        updateViewFromModel(for: .dealing)
    }
    
    @objc private func dealThreeCardsButtonTapped(_ sender: UIButton) {
        dealThreeCards()
    }
    
    @objc private func dealThreeCards() {
        guard !game.cardsOnTable.isEmpty else { return }
        guard !game.cardsInDeck.isEmpty else { return }
        guard game.selectedCards.count != SetGame.SetGameConstants.numberOfCardsInSet else { return }
        
        game.deal(numberOfCards: SetGame.SetGameConstants.numberOfCardsInSet)
        updateViewFromModel(for: .dealing)
    }
    
    @objc private func showHint(_ sender: UIButton) {
        if setCardStackView.cardViews.filter({ $0.state == .hinted }).isEmpty {
            game.addHint()
            updateViewFromModel(for: .highlighting)
            game.removeHint()
        }
    }
    
    @objc private func updateSetGameScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    // MARK: - Set Game Methods
    
    private func updateViewFromModel(for action: SetGameAction) {
        updateSetGameScoreLabel()
        updateButtons()
        updateCardViewsStatus()
        updateCardViewsWithCardsOnTable(for: action)
    }
    
    private func updateButtons() {
        // New Game
        if game.cardsOnTable.isEmpty {
            newGameButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            newGameButton.setTitle("Start Game", for: .normal)
        } else {
            newGameButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            newGameButton.setTitle("New Game", for: .normal)
        }
        
        // Hint
        if game.hintedCards.isEmpty && game.cardsOnTable.count > SetGame.SetGameConstants.numberOfCardsInSet && game.selectedCards.count != SetGame.SetGameConstants.numberOfCardsInSet {
            hintButton.isEnabled = true
        } else {
            hintButton.isEnabled = false
        }
        
        // Deal 3 cards
        if game.selectedCards.count != SetGame.SetGameConstants.numberOfCardsInSet && !game.cardsInDeck.isEmpty {
            dealThreeCardsButton.isEnabled = true
        } else {
            dealThreeCardsButton.isEnabled = false
        }
        
        // New Cards Pile
        if game.cardsInDeck.isEmpty {
            newSetCardsPileButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
            newSetCardsPileButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            newSetCardsPileButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            newSetCardsPileButton.layer.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        }
        
        // Discarded Cards Pile
        if game.matchedCards.isEmpty {
            discardSetCardsPileButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
            discardSetCardsPileButton.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            discardSetCardsPileButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            discardSetCardsPileButton.layer.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        }
    }
    
    private func updateCardViewsStatus() {
        for cardView in setCardStackView.cardViews {
            let setCard = cardView.card!
            
            if game.selectedCards.contains(setCard) {
                if game.selectedCards.count < SetGame.SetGameConstants.numberOfCardsInSet {
                    setCardStackView.setCardViewState(.selected, for: setCard)
                } else {
                    setCardStackView.setCardViewState(.mismatched, for: setCard)
                }
            } else if game.hintedCards.contains(setCard) {
                setCardStackView.setCardViewState(.hinted, for: setCard)
            } else if game.matchedCards.contains(setCard) {
                setCardStackView.setCardViewState(.matched, for: setCard)
            } else {
                setCardStackView.setCardViewState(.normal, for: setCard)
            }
        }
    }
    
    private func updateCardViewsWithCardsOnTable(for action: SetGameAction) {
        switch action {
        case .touching:
            guard game.cardsOnTable != setCardStackView.cardViews.map({ $0.card! }) else { break }
            
            setCardStackView.matchedCards.forEach { setCardView in
                setCardView.needsToRemoveFromTable = true
                cardBehavior.bounceAround(setCardView)
            }
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(
                withTimeInterval: 3.0,
                repeats: false,
                block: { (_) in
                    self.setCardStackView.matchedCards.forEach { setCardView in
                        self.cardBehavior.snapToDiscardedPile(setCardView)
                    }
                }
            )
            fallthrough
        case .dealing:
            game.cardsOnTable.forEach {
                if setCardStackView.getCardView(with: $0) == nil {
                    setCardStackView.addCardView(with: $0)
                    addTapGesture(to: setCardStackView.getCardView(with: $0)!)
                }
            }
            cardBehavior.updateCardsOnTable(in: setCardStackView)
        case .shuffling:
            game.cardsOnTable.forEach { setCard in
                if let setCardView = setCardStackView.getCardView(with: setCard) {
                    setCardStackView.sendSubviewToBack(setCardView)
                }
            }
            cardBehavior.updateCardsOnTable(in: setCardStackView)
        case .highlighting:
            break
        }
    }
    
    // MARK: - Gestures
    
    private func addTapGesture(to setCardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(touchCardView(_:)))
        
        setCardView.addGestureRecognizer(tap)
    }
    
    @objc private func touchCardView(_ recognizer: UITapGestureRecognizer) {
        guard let setCardView = recognizer.view as? SetCardView else { return }
        
        switch recognizer.state {
        case .changed, .ended:
            game.select(card: setCardView.card!)
            updateViewFromModel(for: .touching)
        default:
            break
        }
    }
    
    @objc private func shuffleCards(_ recognizer: UITapGestureRecognizer) {
        guard game.selectedCards.count != SetGame.SetGameConstants.numberOfCardsInSet else { return }
        guard !game.cardsOnTable.isEmpty else { return }
        
        switch recognizer.state {
        case .ended:
            game.shuffleCards(.onTable)
            updateViewFromModel(for: .shuffling)
        default:
            break
        }
    }
    
    // MARK: - Setup Functions
    
    private func setupActionsAndGestures() {
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(_:)))
        setCardStackView.addGestureRecognizer(rotation)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dealThreeCards))
        newSetCardsPileButton.addGestureRecognizer(tap)
        
        newGameButton.addTarget(self, action: #selector(startGame(_:)), for: .touchUpInside)
        dealThreeCardsButton.addTarget(self, action: #selector(dealThreeCardsButtonTapped(_:)), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(showHint(_:)), for: .touchUpInside)
        
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topStackView)
        topStackView.addSubview(setCardStackView)
        topStackView.addSubview(bottomStackView)
        topStackView.addSubview(scoreLabel)
        
        topStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        topStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true
        
        scoreLabel.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 5).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -5).isActive = true
        scoreLabel.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.10).isActive = true
        
        setCardStackView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor).isActive = true
        setCardStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 5).isActive = true
        setCardStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -5).isActive = true
        setCardStackView.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.80).isActive = true
        
        bottomStackView.topAnchor.constraint(equalTo: setCardStackView.bottomAnchor, constant: 5).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 5).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -5).isActive = true
        bottomStackView.heightAnchor.constraint(equalTo: topStackView.heightAnchor, multiplier: 0.10).isActive = true
        
        bottomStackView.addArrangedSubview(newSetCardsPileButton)
        bottomStackView.addArrangedSubview(discardSetCardsPileButton)
        bottomStackView.addArrangedSubview(newGameButton)
        bottomStackView.addArrangedSubview(dealThreeCardsButton)
        bottomStackView.addArrangedSubview(hintButton)
    }
    
}

// MARK: - Extensions

private enum SetGameAction {
    case touching, dealing, shuffling, highlighting
}

// MARK: - Protocol Extensions

extension SetGameViewController: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        animator.items(in: view.bounds).forEach { item in
            if let setCardView = item as? SetCardView, setCardView.needsToRemoveFromTable {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0,
                                                               delay: 0,
                                                               options: [], animations: {},
                                                               completion: cardBehavior.flipOver(setCardView))
            }
        }
    }
}


