//
//  GameViewController.swift
//  MyGames
//
//  Created by Erik Vitelli on 31/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbTitle.text = game.title
        
        if let consoleName = game.console?.name{
            lbConsole.text = consoleName
            lbConsole.isHidden = false
        }
        
        
        if let releaseDate = game.releaseDate{
            // Formata a data
            let formatter = DateFormatter()
            
            // Formata o estilo da data
            formatter.dateStyle = .long
            
            // Informa o locale para o date
            formatter.locale = Locale(identifier: "pt-BR")
            
            lbReleaseDate.text = "Lançamento: \(formatter.string(from: releaseDate))"
        }
        
        if let image = game.cover as? UIImage{
            imgCover.image = image
        }else{
            imgCover.image = UIImage(named: "noCoverFull")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as? AddEditViewController
        vc?.game = self.game
    }
}
