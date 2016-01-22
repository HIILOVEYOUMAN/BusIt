//
//  BusInfoWindow.swift
//  SidebarMenu
//
//  Created by Ivan Alvarado on 1/20/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class BusInfoWindow: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
