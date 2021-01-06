//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Erik Vitelli on 05/06/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController{
    var context: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Dá acesso ao contexto
        return appDelegate.persistentContainer.viewContext
    }
}
