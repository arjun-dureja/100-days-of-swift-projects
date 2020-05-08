//
//  ActionViewController.swift
//  Extension
//
//  Created by Arjun Dureja on 2020-05-04.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done
            , target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(settingsTapped))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem
        {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func settingsTapped() {
        let ac = UIAlertController(title: "Examples", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Website Title", style: .default, handler: {
            [weak self] _ in
            let item = NSExtensionItem()
            let argument: NSDictionary = ["customJavaScript": "alert(document.title)"]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            self?.extensionContext?.completeRequest(returningItems: [item])
        }))
        
        ac.addAction(UIAlertAction(title: "Edit Site", style: .default, handler: {
            [weak self] _ in
            let item = NSExtensionItem()
            let argument: NSDictionary = ["customJavaScript": "document.body.contentEditable='true'"]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            self?.extensionContext?.completeRequest(returningItems: [item])
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
        present(ac, animated: true)
    }

}
