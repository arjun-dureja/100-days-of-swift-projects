//
//  DetailViewController.swift
//  22-Projects13-15-Milestone
//
//  Created by Arjun Dureja on 2020-04-30.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var country: Country?
    var flag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let country = country {
            title = country.name
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["The capital of \(country!.name) is \(country!.capital)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(vc, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        
        let label = UILabel(frame: CGRect(x: 15, y: 7, width: 100, height: 35))
        label.numberOfLines = 0
        view.addSubview(label)
  
        if section == 0 {
            label.text = "Flag"
        } else {
            label.text = "Facts"
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "flag", for: indexPath) as? FlagCell else { fatalError() }
            
            cell.flag.image = UIImage(named: flag!)
            cell.flag.layer.cornerRadius = 10
            cell.flag.layer.borderWidth = 1
            cell.flag.layer.borderColor = UIColor.lightGray.cgColor
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Region: \(country!.region)"
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Capital: \(country!.capital)"
            } else {
                cell.textLabel?.text = "Population: \(String(describing: numberFormatter.string(from: NSNumber(value: country!.population))!))"
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else {
            return 44
        }
    }
}
