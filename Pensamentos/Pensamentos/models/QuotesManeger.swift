//
//  QuotesManeger.swift
//  Pensamentos
//
//  Created by Erik Vitelli on 13/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation

class QuotesManeger{
    let quotes: [Quote]
    
    init() {
        // Solicita ao Bundle a URL  de um arquivo chamado quotes com a extensão json
        let fileURL = Bundle.main.url(forResource: "quotes", withExtension: "json")!
        
        let jsonData = try! Data(contentsOf: fileURL)
        
        //Faz a decodificação de um json
        let jsonDecoder = JSONDecoder()
        quotes = try! jsonDecoder.decode([Quote].self, from: jsonData)
    }
    
    func getRandonQuote()->Quote{
        let index = Int(arc4random_uniform(UInt32(quotes.count)))
        return quotes[index]
    }
}
