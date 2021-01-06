//
//  ViewController.swift
//  SuperSenha
//
//  Created by Erik Vitelli on 24/04/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvTotalPasswords: UITextField!
    @IBOutlet weak var tvNumberOfCharacteres: UITextField!
    @IBOutlet weak var swLetters: UISwitch!

    @IBOutlet weak var swNumbers: UISwitch!
    
    @IBOutlet weak var swCapitalLetters: UISwitch!
    
    @IBOutlet weak var swSpecialCharacters: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let passwordVC = segue.destination as! PassawordsViewController
        
        if let numberOfPassword = Int(tvTotalPasswords.text!){
            passwordVC.numberOfPasswords = numberOfPassword
        }
        
        if let numberOfCharacters = Int(tvNumberOfCharacteres.text!){
            passwordVC.numberOfCharacters = numberOfCharacters
        }
        
        passwordVC.useLetters = swLetters.isOn
        passwordVC.useNumbers = swNumbers.isOn
        passwordVC.useCapitalLetters = swCapitalLetters.isOn
        passwordVC.useSpecialCharacters = swSpecialCharacters.isOn
        
        view.endEditing(true)
    }
}

