//
//  Place.swift
//  QueroConhecer
//
//  Created by Erik Vitelli on 21/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation
import MapKit

struct Place: Codable {
    let name: String
    let latitude : CLLocationDegrees
    let longitude: CLLocationDegrees
    let address : String
    
    var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAddress(with placemark: CLPlacemark)-> String{
        
        var address = ""
        
        if let street = placemark.thoroughfare{
            address += street //rua
            
        }
        if let number = placemark.subThoroughfare{
            address += " \(number)" // número
        }
        
        if let subLocality = placemark.subLocality{
            address += ", \(subLocality)" // Bairro
        }
        
        if let city = placemark.locality{
            address += "\n\(city)" // Cidade
        }
        
        if let state = placemark.administrativeArea{
            address += " - \(state)" // Estado
        }
        
        if let postalCode = placemark.postalCode{
            address += "\nCEP:\(postalCode)" // CEP
        }
        
        if let country = placemark.country{
            address += "\n\(country)" // País
        }
        return address
    }
}
// Informa para o swift como eu comparo dois objetos complexos
extension Place: Equatable{
    static func ==(lhs: Place, rhs: Place) -> Bool{
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
