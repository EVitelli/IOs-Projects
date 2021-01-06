//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Erik Vitelli on 06/06/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation
import  CoreData

class ConsolesManager {
    static let shared = ConsolesManager()
    var consoles: [Console] = []
    
    private init(){
    }
    
    func loadConsoles(with context: NSManagedObjectContext){
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        let fetchRequest:  NSFetchRequest<Console> = Console.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            /*
             - Traz os itens que estão armazenados no banco
             de dados
             - Caso eu tenha uma grande quantidade de dados
             não se recomenda o uso desse método, o ideal
             seria a forma usada no GamesTableViewController
             */
            consoles = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
        }
    }
        
    func deleteConsole(at index: Int, context context: NSManagedObjectContext){
        
        let console = consoles[index]
        /*
         - Deleta um elemento do contexto mas essa
         informação ainda não foi removida do banco
         de dados
         */
        context.delete(console)
        
        do{
            // Persite os dados no banco
            try context.save()
            consoles.remove(at: index)
        }catch{
            print(error.localizedDescription)
        }
    }
}
