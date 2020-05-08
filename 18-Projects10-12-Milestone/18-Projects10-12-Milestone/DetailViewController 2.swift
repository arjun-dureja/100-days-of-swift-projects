//
//  DetailViewController.swift
//  18-Projects10-12-Milestone
//
//  Created by Arjun Dureja on 2020-04-29.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var caption: String?
    var image: String?
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let caption = caption {
            title = caption
        }
        
        if let image = image {
            let path = getDocumentsDirectory().appendingPathComponent(image)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
