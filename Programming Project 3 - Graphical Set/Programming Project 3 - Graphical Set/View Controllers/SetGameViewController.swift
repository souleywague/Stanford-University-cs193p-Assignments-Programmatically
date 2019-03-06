//
//  SetGameViewController.swift
//  Programming Project 3 - Graphical Set
//
//  Created by Souley on 06/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
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
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    
    // MARK: - SetGame Functions
    
    
    // MARK: - Setup Functions
    
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topStackView)
        topStackView.addSubview(boardView)
        topStackView.addSubview(bottomStackView)
        
        topStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        topStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        
        
        bottomStackView.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 10).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 10).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: -10).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor).isActive = true
        
        bottomStackView.addArrangedSubview(newGameButton)
        bottomStackView.addArrangedSubview(scoreLabel)
        bottomStackView.addArrangedSubview(dealButton)
    }
    
}
