//
//  ViewController.swift
//  09-Projects4-6-Milestone
//
//  Created by Arjun Dureja on 2020-04-26.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear List", style: .plain, target: self, action: #selector(newList))
        
        tableView.tableFooterView = UIView(frame: .zero)
        newList()
    }
    
    @objc func newList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoppingList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add Item", message: "Add an item to your shopping list!", preferredStyle: .alert)
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
        if answer.count > 0 {
            shoppingList.insert(answer.lowercased(), at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: [shoppingList.joined(separator: "\n")], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(vc, animated: true)
    }
}

