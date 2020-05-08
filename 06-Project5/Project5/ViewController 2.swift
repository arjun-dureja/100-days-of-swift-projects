//
//  ViewController.swift
//  Project5
//
//  Created by Arjun Dureja on 2020-04-25.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "usedwords") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                usedWords = try jsonDecoder.decode([String].self, from: savedData)
            } catch {
                print("failed to load")
            }
        }
        
        title = defaults.object(forKey: "currentword") as? String
        
        tableView.reloadData()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        save()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word:lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    save()
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up!")
                }
            } else {
                showErrorMessage(errorTitle: "Word already used", errorMessage: "Be more original!")
            }
        } else {
            guard let title = title else { return }
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title.lowercased())")
        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 || word.count == 0 { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        let defaults = UserDefaults.standard
        if let savedData = try? jsonEncoder.encode(usedWords) {
            defaults.set(savedData, forKey: "usedwords")
        }
        defaults.set(title, forKey: "currentword")
    }
}

