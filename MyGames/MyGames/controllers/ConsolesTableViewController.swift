//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Erik Vitelli on 31/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {
    var consolesManager = ConsolesManager.shared    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "aboutSegue"{
            let vc = segue.destination as! ConsoleViewController
            let selectedRow =  tableView.indexPathForSelectedRow!.row
            vc.console = consolesManager.consoles[selectedRow]
            
        }else if segue.identifier == "addConsoleSegue"{
            let vc = segue.destination as! AddEditViewController
            vc.console = nil
            vc.game = nil
            vc.type = "Console"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadConsoles()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let console = consolesManager.consoles[indexPath.row]
        //showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            consolesManager.deleteConsole(at: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let console = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name
        
        
        
        return cell
    }
    
    
    @IBAction func addConsole(_ sender: Any) {
        //showAlert(with: nil)
    }
    
    func loadConsoles(){
        consolesManager.loadConsoles(with: context)
        tableView.reloadData()
    }
    
    func showAlert(with console: Console?){
        let title = console == nil ? "Adicionar" : "Editar"
        
        /*
         Cria o alert que será responsável por solicitar
         o nome da plataforma pro ussuário.
         */
        let alert = UIAlertController(title: title + " plataforma", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nome da plataforma"
            
            if let name = console?.name{
                textField.text = name
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            
            do{
                try self.context.save()
                self.loadConsoles()
            }catch{
                print(error.localizedDescription)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        // Altera a cor dos botões do alert
        alert.view.tintColor = UIColor(named: "second")
        
        // Apresenta o alert na tela
        present(alert, animated: true, completion: nil)
        
    }

}
