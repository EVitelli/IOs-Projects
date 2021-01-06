//
//  WorldCupViewController.swift
//  CampeoesDaCopa
//
//  Created by Erik Vitelli on 15/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class WorldCupViewController: UIViewController {

    @IBOutlet weak var imgWinner: UIImageView!
    @IBOutlet weak var imgLoser: UIImageView!
    @IBOutlet weak var lbWinner: UILabel!
    @IBOutlet weak var lbLoser: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var imgSeparatorWinner: UIImageView!
    @IBOutlet weak var imgSeparatorLoser: UIImageView!
    @IBOutlet weak var imgBackWinner: UIImageView!
    @IBOutlet weak var imgBackLoser: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    var worldCup: WorldCup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "World Cup \(worldCup.year)"
        
        imgWinner.image = UIImage(named: "\(worldCup.winner).png")
        imgLoser.image = UIImage(named: "\(worldCup.vice).png")
        imgSeparatorWinner.image = imgWinner.image
        imgSeparatorLoser.image = imgLoser.image
        imgBackWinner.image = imgWinner.image
        imgBackLoser.image = imgLoser.image
        lbWinner.text = worldCup.winner
        lbLoser.text = worldCup.vice
        lbScore.text = "\(worldCup.winnerScore) x \(worldCup.viceScore)"
        
    }

}


extension WorldCupViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return worldCup.matches.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worldCup.matches[section].games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GamesTableViewCell
        let match = worldCup.matches[indexPath.section]
        
        let game = match.games[indexPath.row]
        
        cell.prepare(with: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return worldCup.matches[section].stage
    }
    
}

extension WorldCupViewController: UITableViewDelegate{
    
}
