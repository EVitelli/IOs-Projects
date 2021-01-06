//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by Erik Vitelli on 10/06/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit
import CoreData

class ConsoleViewController: UIViewController {

    var console: Console!
    var games: [Game] = []
    var fetchedResultController: NSFetchedResultsController<Game>!
    var label = UILabel()
    
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDeveloper: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Você não tem jogos cadastrados nesta plataforma"
        label.textAlignment = .center
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadConsole()
        loadGames()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gameSegue"{
            let vc = segue.destination as! GameViewController
            
            
            if let games = fetchedResultController.fetchedObjects{
                let selectedIndex = tableView.indexPathForSelectedRow!.row
                vc.game = games[selectedIndex]
            }
        }else{
            let vc = segue.destination as! AddEditViewController
            vc.console = console
            vc.game = nil
            vc.type = "Console"
        }
        
    }
    
    func loadConsole(){
        lbName.text = console.name
        
        lbDeveloper.text = console.developer != nil ? "Desenvolvedor: \(console.developer!)" : ""
        
        if let releaseDate = console.releaseDate{
            
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            
            lbReleaseDate.text = "Lançamento: \(formatter.string(from: releaseDate))"
        }
    }
    
    func loadGames(){
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        guard let consoleName = console.name else{return}
        let predicate = NSPredicate(format: "console.name = %@", consoleName)
        
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do{
            try fetchedResultController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
    }
}


extension ConsoleViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        if let game = fetchedResultController.fetchedObjects?[indexPath.row]{
            cell.prepare(with: game)
        }
        
        return cell
    }
    
    
}

extension ConsoleViewController: NSFetchedResultsControllerDelegate{
    // Sempre que um objeto for modificado, dispara esse método
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                do{
                    try context.save()
                }catch{
                    print(error.localizedDescription)
                }
            }
            break
        default:
            tableView.reloadData()
        }
    }
}
