//
//  ViewController.swift
//  22-Projects13-15-Milestone
//
//  Created by Arjun Dureja on 2020-04-30.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let urlString = "https://restcountries.eu/rest/v2/all?fields=name;capital;currencies;population;flag;region"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".png") && item.count == 11 {
                flags.append(item)
            }
        }
        
        flags.sort()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode([Country].self, from: json) {
            countries = jsonCountries
            countries.sort {
                $0.flag < $1.flag
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath) as? CountryCell else {
            fatalError("Unable to dequeue cell")
        }
        
        let country = countries[indexPath.row]
        
        cell.name.text = country.name
        cell.flagImage.image = UIImage(named: flags[indexPath.row])
        cell.flagImage.layer.cornerRadius = 10
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        
        vc.country = countries[indexPath.row]
        vc.flag = flags[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

