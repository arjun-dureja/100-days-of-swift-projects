//
//  Picture.swift
//  18-Projects10-12-Milestone
//
//  Created by Arjun Dureja on 2020-04-29.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
