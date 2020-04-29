//
//  ViewController.swift
//  Project1
//
//  Created by Arjun Dureja on 2020-04-23.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        performSelector(inBackground: #selector(loadImages), with: nil)
        
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue picture cell.")
        }
        cell.imageVIew.image = UIImage(named: pictures[indexPath.item])
        cell.name.text = pictures[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imageNum = indexPath.row+1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Download this app!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.backBarButtonItem
        present(vc, animated: true)
    }


}

