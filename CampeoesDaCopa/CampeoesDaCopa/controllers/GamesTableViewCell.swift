//
//  GamesTableViewCell.swift
//  CampeoesDaCopa
//
//  Created by Erik Vitelli on 20/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var lbHome: UILabel!
    @IBOutlet weak var lbAway: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbGameDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(with game: Game){
        imgHome.image = UIImage(named: "\(game.home).png")
        imgAway.image = UIImage(named: "\(game.away).png")
        lbHome.text = game.home
        lbAway.text = game.away
        lbScore.text = game.score
        lbGameDate.text = game.date
        
    }

}
