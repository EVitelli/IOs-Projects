//
//  Car.swift
//  Carangas
//
//  Created by Erik Vitelli on 10/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

class Car: Codable{
    var _id: String?, brand: String = "", gasType: Int = 0
    var name: String = "", price: Double = 0.0
    
    var gas: String{
        switch gasType {
        case 1:
            return "Flex"
        case 2:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}

struct Brand: Codable {
    let fipe_name: String
}
