//
//  AboutConsoleViewController.swift
//  MyGames
//
//  Created by Erik Vitelli on 10/06/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {
    @IBOutlet weak var lbConsoleName: UILabel!
    @IBOutlet weak var lbDeveloper: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    
    var console: Console!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbConsoleName.text = console.name
        lbDeveloper.text =  console.developer
        
        if let releaseDate = console.releaseDate{
            
            // Formata a data
            let formatter = DateFormatter()
            
            // Formata o estilo da data
            formatter.dateStyle = .long
            
            // Informa o locale para o date
            formatter.locale = Locale(identifier: "pt-BR")
            
            lbReleaseDate.text = "Lançamento: \(formatter.string(from: releaseDate))"
        }
        if let image = console.photo as? UIImage{
            imgCover.image = image
        }else{
            imgCover.image = UIImage(named: "noCoverFull")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editConsoleSegue"{
            let vc = segue.destination as! AddEditViewController
            vc.console = self.console
            vc.game = nil
            vc.type = "Console"
        }
    }
}
