//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Erik Vitelli on 07/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tfStateTaxes: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfDolar.text = taxesCalculator.getFormattedValue(of: taxesCalculator.dolar, withCurrency: "")
        tfIOF.text = taxesCalculator.getFormattedValue(of: taxesCalculator.iof, withCurrency: "")
        tfStateTaxes.text = taxesCalculator.getFormattedValue(of: taxesCalculator.stateTax, withCurrency: "")
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setValues(){
        taxesCalculator.dolar = taxesCalculator.convertToDouble(tfDolar.text!)
        taxesCalculator.iof = taxesCalculator.convertToDouble(tfIOF.text!)
        taxesCalculator.stateTax = taxesCalculator.convertToDouble(tfStateTaxes.text!)
        
        tfDolar.text = taxesCalculator.getFormattedValue(of: taxesCalculator.dolar, withCurrency: "")
        tfIOF.text = taxesCalculator.getFormattedValue(of: taxesCalculator.iof, withCurrency: "")
        tfStateTaxes.text = taxesCalculator.getFormattedValue(of: taxesCalculator.stateTax, withCurrency: "")
    }

}

extension SettingsViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        setValues()
    }
}
