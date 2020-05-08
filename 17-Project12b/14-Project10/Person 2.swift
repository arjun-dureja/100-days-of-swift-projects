//
//  Person.swift
//  14-Project10
//
//  Created by Arjun Dureja on 2020-04-28.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
