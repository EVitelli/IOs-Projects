//
//  ViewController.swift
//  IMC
//
//  Created by Erik Vitelli on 30/03/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Chama quando a view é criada
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Esconde a view de resultado
        viResult.isHidden = true
    }

    // Outlets de dos componentes da tela
    @IBOutlet weak var tfPeso: UITextField!
    @IBOutlet weak var tfAltura: UITextField!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var ivResult: UIImageView!
    @IBOutlet weak var viResult: UIView!
    
    // Action do botão
    @IBAction func btCalcular(_ sender: Any) {
        var imc: Float = 0.0
        var result = ""
        var image = ""
        
        // Verifica se a altura e o peso não são nulos
        if let altura = Float(tfAltura.text!),let peso =  Float(tfPeso.text!){
           imc = calculaIMC(altura: altura, peso: peso)
        }
        
        
        switch imc {
            case 0..<16:
                result = "Magreza"
                image = "abaixo"
            case 16..<18.5:
                result = "Abaixo do peso"
                image = "abaixo"
            case 18.5..<25:
                result = "Peso ideal"
                image = "ideal"
            case 25..<30:
                result = "Sobre peso"
                image = "sobre"
            default:
                result = "Obesidade"
                image = "obesidade"
        }
        /*Int(imc) converte o imc para um inteiro para não exibir as casas decimais
         */
        lbResult.text = "\(Int(imc)): \(result)"
        ivResult.image = UIImage(named: image)
        
        viResult.isHidden = false
        // Remove o foco dos textFields
        view.endEditing(true)
        
    }
    // Método chamado ao clicar em um componente que não tem foco
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Função criada pra calcular o imc
    func calculaIMC(altura: Float, peso: Float)-> Float{
        return peso/(altura*altura)
    }
}

