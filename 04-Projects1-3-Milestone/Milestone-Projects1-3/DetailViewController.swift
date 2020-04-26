//
//  DetailViewController.swift
//  Milestone-Projects1-3
//
//  Created by Arjun Dureja on 2020-04-25.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var flagImageName: String?
    var flagName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = flagImageName {
            flagName = name.replacingOccurrences(of: ".png", with: "").uppercased()
        }
        
        title = flagName
        navigationItem.largeTitleDisplayMode = .never
        
        if let image = flagImageName {
            imageView.image = UIImage(named: image)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1.0) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, flagName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.backBarButtonItem
        present(vc, animated: true)
    }
    
}
