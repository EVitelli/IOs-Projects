//
//  WorldCupTableViewCell.swift
//  CampeoesDaCopa
//
//  Created by Erik Vitelli on 16/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class WorldCupTableViewCell: UITableViewCell {

    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var imgWinner: UIImageView!
    @IBOutlet weak var imgLoser: UIImageView!
    @IBOutlet weak var lbWinner: UILabel!
    @IBOutlet weak var lbLoser: UILabel!
    @IBOutlet weak var lbWinnerScore: UILabel!
    @IBOutlet weak var lbLoserScore: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with cup: WorldCup){
        lbYear.text = "\(cup.year)"
        imgWinner.image = UIImage(named: "\(cup.winner).png")
        imgLoser.image = UIImage(named: "\(cup.vice).png")
        lbWinner.text = cup.winner
        lbLoser.text = cup.vice
        lbWinnerScore.text = cup.winnerScore
        lbLoserScore.text = cup.viceScore
        lbCountry.text = cup.country
    }

}
