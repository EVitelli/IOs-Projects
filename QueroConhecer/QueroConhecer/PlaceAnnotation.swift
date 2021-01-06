//
//  PlaceAnnotation.swift
//  QueroConhecer
//
//  Created by Erik Vitelli on 23/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation
import  MapKit

enum PlaceType{
    case place, pointOfInterest
}

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: PlaceType
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, type: PlaceType) {
        self.coordinate = coordinate
        self.type = type
    }
    
    
}
