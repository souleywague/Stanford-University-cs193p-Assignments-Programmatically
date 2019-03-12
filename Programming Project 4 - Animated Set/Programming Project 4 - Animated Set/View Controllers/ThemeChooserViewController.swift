//
//  ThemeChooserViewController.swift
//  Programming Project 4 - Animated Set
//
//  Created by Souley on 10/03/2019.
//  Copyright © 2019 Souley. All rights reserved.
//

import UIKit

class ThemeChooserViewController: UIViewController {
    
    // MARK: - User Interface Properties
    
    private lazy var themeChooserStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var animalsThemeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Animals", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var sportsThemeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Sports", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var facesThemeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Faces", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var clothesThemeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Clothes", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var foodThemeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Food", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = .pi
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Delegates and Navigation Properties
    
    weak var delegate: ThemeChooserDelegate?
    
    private let storedConcentrationGameViewController = ConcentrationGameViewController()
    
    // MARK: - Theme Chooser Properties

    private var themes: [String: Theme] = [
        "Animals": Theme(name: "Animals", boardColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), cardColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
                         emojis: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷"]),
        "Sports": Theme(name: "Sports", boardColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cardColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
                         emojis: ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🥅","🏒","🥊"]),
        "Faces": Theme(name: "Faces", boardColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cardColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),
                        emojis: ["😀","😅","😇","😍","😋","🤪","🧐","😎","🤩","😭","🤬","😱","🤮"]),
        "Clothes": Theme(name: "Clothes", boardColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), cardColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
                       emojis: ["🧥","👚","👕","👖","👔","👗","👙","👘","👠","🧤","👑","🎒","🌂"]),
        "Food": Theme(name: "Food", boardColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cardColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
                       emojis: ["🍏","🍐","🧀","🍌","🍉","🍇","🥥","🍆","🍑","🥑","🥩","🥟","🍕"])
    ]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Themes"

        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLayout()
        setupActions()
    }
    
    // MARK: - Actions
    
    @objc func themeButtonTapped(_ sender: UIButton) {
        
        guard let themeName = sender.currentTitle else { return }
        guard let theme = themes[themeName] else { return }
        
        if (splitViewController?.isCollapsed)! {
            storedConcentrationGameViewController.didChooseTheme(theme)
            navigationController?.showDetailViewController(storedConcentrationGameViewController, sender: self)
        } else {
            delegate?.didChooseTheme(theme)
        }
    }
    
    // MARK: - Setup Functions

    private func setupActions() {
        animalsThemeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        sportsThemeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        facesThemeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        clothesThemeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        foodThemeButton.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(themeChooserStackView)
        
        themeChooserStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5).isActive = true
        themeChooserStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        themeChooserStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5).isActive = true
        themeChooserStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5).isActive = true
        
        themeChooserStackView.addArrangedSubview(animalsThemeButton)
        themeChooserStackView.addArrangedSubview(sportsThemeButton)
        themeChooserStackView.addArrangedSubview(facesThemeButton)
        themeChooserStackView.addArrangedSubview(clothesThemeButton)
        themeChooserStackView.addArrangedSubview(foodThemeButton)
    }
    
    private func setupDelegates() {
        if let splitViewController = tabBarController?.viewControllers?.first as? UISplitViewController,
            let navigationViewController = splitViewController.viewControllers.last as? UINavigationController,
            let concentrationViewController = navigationViewController.viewControllers.first as? ConcentrationGameViewController {
            delegate = concentrationViewController
        }
    }
    
}
