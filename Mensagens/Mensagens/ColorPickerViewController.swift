//
//  ColorPickerViewController.swift
//  Mensagens
//
//  Created by Erik Vitelli on 01/05/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit

/*
 Uma variável somente pode ser weak caso ela seja uma class
 */
protocol colorPickerDelegate: class {
    func applyColor(color: UIColor)
}

class ColorPickerViewController: UIViewController {
    weak var reference: colorPickerDelegate?
    
    @IBOutlet weak var viColor: UIView!
    
    @IBOutlet weak var tfRed: UITextField!
    @IBOutlet weak var tfGreen: UITextField!
    @IBOutlet weak var tfBlue: UITextField!
    
    @IBOutlet weak var slRed: UISlider!
    @IBOutlet weak var slGreen: UISlider!
    @IBOutlet weak var slBlue: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfRed.delegate = self
        tfGreen.delegate = self
        tfBlue.delegate = self

    }
    
    @IBAction func Done(_ sender: Any) {
        reference?.applyColor(color: viColor.backgroundColor!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: Any?) {
        viColor.backgroundColor = UIColor(red: CGFloat(slRed.value), green: CGFloat(slGreen.value), blue: CGFloat(slBlue.value), alpha: 1.0)
        
        tfRed.text = "\(Int(slRed.value * 255.0))"
        tfGreen.text = "\(Int(slGreen.value * 255.0))"
        tfBlue.text = "\(Int(slBlue.value * 255.0))"
    }
}

extension ColorPickerViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if var red = Int(tfRed.text!){
            if red > 255{
                red = 255
            }
            slRed.value = Float(Double(red) / 255.0)
        }else{
            tfRed.text = "0"
            slRed.value = 0
        }
        
        if var green = Int(tfGreen.text!){
            if green > 255{
                green = 255
            }
            slGreen.value = Float(Double(green) / 255.0)
        }else{
            tfGreen.text = "0"
            slGreen.value = 0
            
        }
        
        if var blue = Int(tfBlue.text!){
            if blue > 255{
                blue = 255
            }
            slBlue.value = Float(Double(blue) / 255.0)
        }else{
            tfBlue.text = "0"
            slBlue.value = 0
        }
        
        changeColor(nil)
        textField.resignFirstResponder()
        return true
    }
}
