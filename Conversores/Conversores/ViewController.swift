//
//  ViewController.swift
//  Conversores
//
//  Created by Erik Vitelli on 03/04/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbResultUnit: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btLeft: UIButton!
    @IBOutlet weak var btRight: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convert(nil)
    }
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        switch lbTitle.text!{
            case "Temperatura":
                lbTitle.text = "Peso"
                btLeft.setTitle("Quilograma", for: .normal)
                btRight.setTitle("Libra", for: .normal)
            case "Peso":
                lbTitle.text = "Moeda"
                btLeft.setTitle("Real", for: .normal)
                btRight.setTitle("Dólar", for: .normal)
            case "Moeda":
                lbTitle.text = "Distância"
                btLeft.setTitle("Metro", for: .normal)
                btRight.setTitle("Quilômetro", for: .normal)
            default:
                lbTitle.text = "Temperatura"
                btLeft.setTitle("Celsius", for: .normal)
                btRight.setTitle("Fahrenheit", for: .normal)
        }
        convert(nil)
    }
    
    @IBAction func convert(_ sender: UIButton?){
        if let sender = sender{
            if sender == btLeft{
                btRight.alpha = 0.5
            }else{
                btLeft.alpha = 0.5
            }
            sender.alpha = 1.0
        }
        if tfValue.text!.isEmpty{
            tfValue.text = "0";
        }
        
        switch lbTitle.text!{
            case "Temperatura":
                calcTemperature()
            case "Peso":
                calcWeight()
            case "Moeda":
                calcCurrence()
            default:
                calcDistance()
        }
        view.endEditing(true)
        let result = Double(lbResult.text!)
        lbResult.text! = String(format: "%.2f", result!)
    }
    
    func calcTemperature() {
        guard let temperature = Double(tfValue.text!) else {return}
        
        if btLeft.alpha == 1.0 {
            lbResultUnit.text = "Fahrenheit (Fº)"
            lbResult.text = "\(temperature * 1.8 + 32.0)"
        }else{
            lbResultUnit.text = "Celsius (Cº)"
            lbResult.text = "\((temperature-32.0)/1.8)"
        }
    }
    
    func calcWeight() {
        guard let weight = Double(tfValue.text!) else {return}
        
        if btLeft.alpha == 1.0 {
            lbResultUnit.text = "Libra (lb)"
            lbResult.text = "\(weight * 2.2046)"
        }else{
            lbResultUnit.text = "Quilograma (kg)"
            lbResult.text = "\(weight / 2.2046)"
        }
    }
    
    func calcCurrence() {
        guard let currence = Double(tfValue.text!) else {return}
        
        if btLeft.alpha == 1.0 {
            lbResultUnit.text = "Dolar (US$)"
            lbResult.text = "\(currence / 3.5)"
        }else{
            lbResultUnit.text = "Real (R$)"
            lbResult.text = "\(currence * 3.5)"
        }
    }
    
    func calcDistance() {
        guard let distance = Double(tfValue.text!) else {return}
        
        if btLeft.alpha == 1.0 {
            lbResultUnit.text = "Quilômetro (km)"
            lbResult.text = "\(distance / 1000.0)"
        }else{
            lbResultUnit.text = "Metros (m)"
            lbResult.text = "\(distance * 1000.0)"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        convert(nil)
        view.endEditing(true)
    }
    
}

