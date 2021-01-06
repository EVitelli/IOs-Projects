//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Erik Vitelli on 31/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Game>!
    var label = UILabel()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadGames()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue"{
            let vc = segue.destination as! GameViewController
            
            
            if let games = fetchedResultController.fetchedObjects{
                let selectedIndex = tableView.indexPathForSelectedRow!.row
                vc.game = games[selectedIndex]
            }
        }
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
        /*
         Adiciona a search controller na tela
         com a atualização do ios 11 agora podemos colocar
         a search controller dentro do navigation item
         */
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func loadGames(filtering: String = ""){
        // 
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        // Define o tipo de ordenação dos dados
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        /*
         No array eu posso passar mais sortDescriptor para ordenar caso os valores sejam iguais
         */
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty{
            /*
             Predicate - um conjunto de regras que você implementa quando você vai
             fazer uma pesquisa em um banco de dados
             */
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            
            // Aplica o filtro da pesquisa na select
            fetchRequest.predicate = predicate
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        // Busca as informações no contexto
        do{
          try fetchedResultController.performFetch()
        }catch{
            print(error.localizedDescription)
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultController.fetchedObjects?.count ?? 0

        tableView.backgroundView = count == 0 ? label : nil
        return count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else{
            return cell
        }

        cell.prepare(with: game)
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Recupera o jogo selecionado
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            
            /*
             Solicita ao contexto para exclui
             Quando o método .delete é chamado ele chama o método do delegate
             */
            context.delete(game)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GamesTableViewController: NSFetchedResultsControllerDelegate{
    // Sempre que um objeto for modificado, dispara esse método
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch  type{
        case .delete:
            if let indexPath = indexPath{
                // Deleta a linha da tabela
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

extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // Acionado quando o usuário clica pra cancelar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
        tableView.reloadData()
    }
    
    // Acionado quando o usuário clica pra fazer a pesquisa
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Recupera o valor passado na searchBar e passa como parametro no filtro
        loadGames(filtering: searchBar.text!)
        tableView.reloadData()
    }
}
