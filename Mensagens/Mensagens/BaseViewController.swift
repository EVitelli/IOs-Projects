//
//  BaseViewController.swift
//  Mensagens
//
//  Created by Erik Vitelli on 30/04/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var lbMessage: UILabel?
    
    var message: Message!
    
    @IBAction func changeColor(){
        if let reference = self as? colorPickerDelegate{
            let colorPicker = storyboard?.instantiateViewController(withIdentifier: "colorPickerView") as! ColorPickerViewController
            colorPicker.modalPresentationStyle = .overCurrentContext
            colorPicker.reference = reference
            present(colorPicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
