//
//  ViewController.swift
//  10-Project7
//
//  Created by Arjun Dureja on 2020-04-26.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Petitions"
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchItem))
        
        let urlString:String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    @objc func searchItem() {
        let ac = UIAlertController(title: "Search", message: "Enter your query", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let query = ac?.textFields?[0].text else { return }
            self?.submit(query)
        })
        
        present(ac, animated: true)
    }
    
    func submit(_ query: String) {
        if query.isEmpty {
            filteredPetitions = petitions
            tableView.reloadData()
            return
        }
        
        filteredPetitions.removeAll()
        for i in 0..<petitions.count {
            if petitions[i].title.contains(query) || petitions[i].body.contains(query) {
                filteredPetitions.append(petitions[i])
            }
        }
        
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This data is provided by the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

