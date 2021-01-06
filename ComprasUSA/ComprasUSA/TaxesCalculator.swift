//
//  TaxesCalculator.swift
//  ComprasUSA
//
//  Created by Erik Vitelli on 09/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation

class TaxesCalculator{
    
    static let shared = TaxesCalculator()
    var dolar: Double = 3.5
    var iof: Double = 6.38
    var stateTax: Double = 7.0
    var shoppingValue: Double = 0.0
    
    let formatter = NumberFormatter()
    
    var shoppingValueInReal: Double {
        return shoppingValue * dolar
    }
    
    var stateTaxValue: Double{
        return shoppingValue * stateTax / 100
    }
    
    var iofValue: Double{
        return (shoppingValue + stateTax) * iof / 100
    }
    
    private init(){
        formatter.usesGroupingSeparator = true
    }
    
    func calculate(usingCreditCard: Bool)-> Double{
        var finalValue = shoppingValue + stateTaxValue
        
        if usingCreditCard{
            finalValue += iofValue
        }
        return finalValue * dolar
    }
    
    func convertToDouble(_ string: String)-> Double{
        //trata o número formatado com nenhum estilo
        formatter.numberStyle = .none
        return formatter.number(from: string)!.doubleValue
    }
    
    func getFormattedValue(of value: Double, withCurrency currencySymbol: String)-> String{
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.alwaysShowsDecimalSeparator = true
        
        return formatter.string(for: value)!
    }
}
