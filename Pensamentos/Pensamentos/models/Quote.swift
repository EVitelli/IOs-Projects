//
//  Quote.swift
//  Pensamentos
//
//  Created by Erik Vitelli on 13/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation

// quote implementa o protocolo codable
struct Quote: Codable /*Encodable e Decodable*/ {
    
    let quote: String
    let author: String
    let image: String
    
    var quoteFormatted: String{
        return "“" + quote + "”"
    }
    
    var authorFormated: String{
        return "- \(author) -"
    }
}
