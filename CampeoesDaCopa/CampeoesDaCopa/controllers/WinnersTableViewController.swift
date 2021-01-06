//
//  WinnersTableViewController.swift
//  CampeoesDaCopa
//
//  Created by Erik Vitelli on 15/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class WinnersTableViewController: UITableViewController {

    var worldCups: [WorldCup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWorldCups()
    
    }

    // MARK: - Table view data source

    // Quando eu utilizo apenas uma seção, esse método pode ser excluído
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return worldCups.count
    }
    
    // chamado sempre que a tela for apresentar uma célula
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         Pega a celula que acabou de sair da tela e
         reutiliza ela pra criar a nova
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorldCupTableViewCell
        
        let worldCup = worldCups[indexPath.row]
        
        cell.prepare(with: worldCup)
        
        return cell
    }
    
    func loadWorldCups(){
        let fileURL = Bundle.main.url(forResource: "winners.json", withExtension: nil)!
        let jsonData = try! Data(contentsOf: fileURL)
        do{
            worldCups = try! JSONDecoder().decode([WorldCup].self, from: jsonData)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WorldCupViewController
        
        let index = tableView.indexPathForSelectedRow!.row
        let worldCup = worldCups[index]
        
        vc.worldCup = worldCup
        
        
    }

}
