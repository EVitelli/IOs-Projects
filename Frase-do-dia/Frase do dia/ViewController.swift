//
//  ViewController.swift
//  Frase do dia
//
//  Created by Erik Vitelli on 29/03/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var frases: [String] = []
    var numAnterior: Int?
    
    @IBOutlet weak var labelFrase: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializaFrases()
        labelFrase.text = selecionaFrase()
    }

    @IBAction func novaFraseBt(_ sender: Any) {
        labelFrase.text = selecionaFrase()
    }
    
    func inicializaFrases(){
        frases.append("Tente ser feliz ao invés de tentar ser perfeito")
        
        frases.append("Não faz bem viver sonhando e se esquecer de viver.")
        
        frases.append("A felicidade pode ser encontrada mesmo nas horas mais difíceis, se você lembrar de acender a luz.")
        
        frases.append("A verdade é uma coisa bela e terrível, por isso deve ser tratada com grande cautela.")
        
        frases.append("Palavras são, na minha nada humilde opinião, nossa inesgotável fonte de magia. Capazes de formar grandes sofrimentos e também de remediá-los.")
        
        frases.append("Não tenha pena dos mortos. Tenha pena dos vivos, e acima de tudo, daqueles que vivem sem amor.")
    }
    
    func selecionaFrase()-> String{
        let numAleatorio = Int(arc4random_uniform(UInt32(frases.count)))
        
        if numAnterior == nil{
            numAnterior = numAleatorio
            return frases[numAleatorio]
        }else if numAnterior == numAleatorio {
            return selecionaFrase()
        }
        
        return frases[numAleatorio]
    }
    
}

