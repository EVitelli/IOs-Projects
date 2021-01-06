//
//  PassawordsViewController.swift
//  SuperSenha
//
//  Created by Erik Vitelli on 24/04/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class PassawordsViewController: UIViewController {
    
    var numberOfCharacters =  10
    var numberOfPasswords = 1
    var useLetters: Bool!
    var useNumbers: Bool!
    var useCapitalLetters: Bool!
    var useSpecialCharacters: Bool!
    
    var passwordGenerator: PasswordGenerator!
    
    @IBOutlet weak var tvPasswords: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Total de senhas: \(numberOfPasswords)"
        passwordGenerator = PasswordGenerator(numberOfCharacters: self.numberOfCharacters, numberOfPassword: self.numberOfPasswords, useLetters: self.useLetters!, useNumbers: self.useNumbers!, useCapitalLetters: self.useCapitalLetters!, useSpecialCharacters: self.useSpecialCharacters!)
        generatePasswords()
    }
    
    func generatePasswords(){
        tvPasswords.scrollRangeToVisible(NSRange(location: 0, length: 0))
        tvPasswords.text = ""
        
        let passwords = passwordGenerator.generate(total: numberOfPasswords)
        
        for password in passwords{
            tvPasswords.text.append(password + "\n\n")
        }
    }

    @IBAction func generate(_ sender: UIButton) {
        generatePasswords()
    }
    
}
