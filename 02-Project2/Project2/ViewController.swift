//
//  ViewController.swift
//  Project2
//
//  Created by Arjun Dureja on 2020-04-24.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highScore = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .done, target: self, action: #selector(scoreTapped))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highscore")
        
        askQuestion()
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        if questionsAsked == 10 {
            let finalAC: UIAlertController!
            if score > highScore {
                finalAC = UIAlertController(title: "Game Over", message: "Your final score is \(score), you beat your highscore!", preferredStyle: .alert)
                finalAC.addAction(UIAlertAction(title: "New Game", style: .default, handler: nil))
                highScore = score
                save()
            } else {
                finalAC = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)
                finalAC.addAction(UIAlertAction(title: "New Game", style: .default, handler: nil))
            }
            present(finalAC, animated: true)
            score = 0
            questionsAsked = 0
            updateTitle()
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        updateTitle()
    }
    
    func updateTitle() {
        title = countries[correctAnswer].uppercased()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        questionsAsked += 1
        
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! You selected \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        updateTitle()
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
    @objc func scoreTapped() {
        let ac = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        
        present(ac, animated: true)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highscore")
    }
    
}

