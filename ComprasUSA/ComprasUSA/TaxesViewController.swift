//
//  TaxesViewController.swift
//  ComprasUSA
//
//  Created by Erik Vitelli on 07/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class TaxesViewController: UIViewController {

    @IBOutlet weak var lbDolar: UILabel!
    @IBOutlet weak var lbStateTax: UILabel!
    @IBOutlet weak var lbIOFDescription: UILabel!
    @IBOutlet weak var lbIOF: UILabel!
    @IBOutlet weak var swCreditCard: UISwitch!
    @IBOutlet weak var lbReal: UILabel!
    @IBOutlet weak var lbStateTaxDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateTaxes()
    }
    
    @IBAction func changeIOF(_ sender: Any) {
        calculateTaxes()
    }
    
    
    
    func calculateTaxes(){
        let stateTax = taxesCalculator.getFormattedValue(of: taxesCalculator.stateTax, withCurrency: "")
        let iof = taxesCalculator.getFormattedValue(of: taxesCalculator.iof, withCurrency: "")
        
        let shoppingValue = taxesCalculator.getFormattedValue(of: taxesCalculator.shoppingValue, withCurrency: "US$ ")
        let stateTaxValue = taxesCalculator.getFormattedValue(of: taxesCalculator.stateTaxValue, withCurrency: "US$ ")
        let iofValue = taxesCalculator.getFormattedValue(of: taxesCalculator.iofValue, withCurrency: "US$ ")
        
        lbStateTaxDescription.text = "Imposto do estado (\(stateTax)%)"
        lbIOFDescription.text = "I.O.F (\(iof)%)"
        
        lbDolar.text = shoppingValue
        lbStateTax.text = stateTaxValue
        lbIOF.text = iofValue
        
        let real =  taxesCalculator.calculate(usingCreditCard: swCreditCard.isOn)
        lbReal.text = taxesCalculator.getFormattedValue(of: real, withCurrency: "R$ ")
    }
    
}
