//
//  ViewController.swift
//  Gerador_de_numeros_aleatorios
//
//  Created by Erik Vitelli on 02/02/19.
//  Copyright © 2019 curso IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultado: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btGerarNumero(_ sender: Any) {
        let numero = arc4random_uniform(99)
        
        resultado.text = "\(numero + 1)"
        
    }
    
}

