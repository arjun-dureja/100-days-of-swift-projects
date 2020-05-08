//
//  ViewController.swift
//  Milestone-Projects1-3
//
//  Created by Arjun Dureja on 2020-04-24.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".png") && item.count == 6 {
                flags.append(item)
            }
        }
        
        flags.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row].replacingOccurrences(of: ".png", with: "").uppercased()

        cell.imageView?.image = image(UIImage(named: flags[indexPath.row])!, withSize: CGSize(width: 50, height: 30))

        return cell
    }
    
    func image( _ image:UIImage, withSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.flagImageName = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    


}

