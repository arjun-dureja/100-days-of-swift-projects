//
//  Capital.swift
//  23-Project16
//
//  Created by Arjun Dureja on 2020-05-01.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
