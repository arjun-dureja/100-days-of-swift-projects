//
//  ViewController.swift
//  13-Projects7-9-Milestone
//
//  Created by Arjun Dureja on 2020-04-27.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var words = [String]()
    var currentWord: String = ""
    var hiddenWord: String = "" {
        didSet {
            wordLabel.text = hiddenWord
        }
    }
    var wordLabel: UILabel!
    var letterButtons = [UIButton]()
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", " ", "Y", "Z"]
    var usedLetters = [String]()
    var hangMan: UIImageView!
    var guesses = 0 {
        didSet {
            hangMan.image = UIImage(named: "image\(guesses+1)")
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        title = "Hangman"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGame))
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
        wordLabel.textColor = .black
        wordLabel.textAlignment = .center
        view.addSubview(wordLabel)
        
        hangMan = UIImageView()
        hangMan.translatesAutoresizingMaskIntoConstraints = false
        hangMan.image = UIImage(named: "image\(guesses+1)")
        view.addSubview(hangMan)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        	
        NSLayoutConstraint.activate([
            wordLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -15),
            
            hangMan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -150),
            hangMan.widthAnchor.constraint(equalToConstant: 800),
            hangMan.heightAnchor.constraint(equalToConstant: 750),
            hangMan.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -120),
            
            buttonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        var i = 0

        for row in 0..<7 {
            for column in 0..<4 {
                if i == 27 {
                    break
                }
                let letterButton = UIButton(type: .system)
                letterButton.translatesAutoresizingMaskIntoConstraints = false
                letterButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
                letterButton.setTitle(letters[i], for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                buttonsView.addSubview(letterButton)
                
                letterButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: CGFloat(column*95) + 10).isActive = true
                letterButton.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: CGFloat(row*48)).isActive = true
                
                i+=1
                
                letterButtons.append(letterButton)
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text?.lowercased() else { return }
        sender.isHidden = true
        usedLetters.append(buttonText)
        let tempHiddenWord = hiddenWord
        hiddenWord = ""
        
        for letter in currentWord {
            if usedLetters.contains(String(letter)) {
                hiddenWord += "\(String(letter).uppercased()) "
            } else {
                hiddenWord += "_ "
            }
        }
        
        if hiddenWord == tempHiddenWord {
            guesses += 1
            if guesses == 7 {
                let ac = UIAlertController(title: "Game Over", message: "You lost! The word was \(currentWord).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGame))
                present(ac, animated: true)
            }
        }
        
        if !hiddenWord.contains("_") {
            let ac = UIAlertController(title: "Winner!", message: "Congratulations you won! Number of guesses: \(guesses).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGame))
            present(ac, animated: true)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadGame), with: nil)
    }
    
    @objc func loadGame() {
        if let wordsFileURL = Bundle.main.url(forResource: "words", withExtension: ".txt") {
            if let wordsContents = try? String(contentsOf: wordsFileURL) {
                words = wordsContents.components(separatedBy: "\n")
            }
        }
        performSelector(onMainThread: #selector(newGame), with: nil, waitUntilDone: false)
    }
    
    @objc func newGame(_ action: UIAlertAction) {
        guard let currentWord = words.randomElement() else { return }
        
        hiddenWord = ""
        usedLetters.removeAll()
        guesses = 0
        
        for button in letterButtons {
            button.isHidden = false
        }
        
        for _ in currentWord {
            hiddenWord += "_ "
        }
        
        self.currentWord = currentWord
    }


}

