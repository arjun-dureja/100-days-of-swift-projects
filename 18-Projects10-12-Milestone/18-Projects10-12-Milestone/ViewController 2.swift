//
//  ViewController.swift
//  18-Projects10-12-Milestone
//
//  Created by Arjun Dureja on 2020-04-29.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedData)
            } catch {
                print("Failed")
            }
        }
    }
    
    @objc func addTapped(){
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        
        self.present(picker, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Table view error")
        }
        
        let picture = pictures[indexPath.row]
        
        cell.caption.text = picture.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(picture.image)
        cell.picture.image = UIImage(contentsOfFile: path.path)
        cell.picture.layer.cornerRadius = 10
        	
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.caption = pictures[indexPath.row].caption
            vc.image = pictures[indexPath.row].image
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pictures.remove(at: indexPath.row)
            save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Add a caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            
            let picture = Picture(image: imageName, caption: caption)
            self?.pictures.insert(picture, at: 0)
            self?.save()
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        })
        present(ac, animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("failed to save")
        }
    }


}

