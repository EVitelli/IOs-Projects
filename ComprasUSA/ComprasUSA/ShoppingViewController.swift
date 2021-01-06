//
//  ViewController.swift
//  ComprasUSA
//
//  Created by Erik Vitelli on 06/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ShoppingViewController: UIViewController {

   // @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var lbRealDescription: UILabel!
    @IBOutlet weak var lbReal: UILabel!
    @IBOutlet weak var tfDolar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAmmount()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setAmmount()
        tfDolar.resignFirstResponder()
    }
    
    func setAmmount(){
        taxesCalculator.shoppingValue = taxesCalculator.convertToDouble(tfDolar.text!)
        lbReal.text = taxesCalculator.getFormattedValue(of: taxesCalculator.shoppingValue * taxesCalculator.dolar, withCurrency: "R$ ")
        
        let dolar = taxesCalculator.getFormattedValue(of: taxesCalculator.dolar, withCurrency: "R$ ")
        lbRealDescription.text = "Valor sem impostos (Dólar atual \(dolar))"
        tfDolar.text = taxesCalculator.getFormattedValue(of: taxesCalculator.shoppingValue, withCurrency: "")
    }

}

