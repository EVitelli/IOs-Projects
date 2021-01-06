//
//  Configuration.swift
//  Pensamentos
//
//  Created by Erik Vitelli on 13/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import Foundation
enum UserDefaultKeys: String{
    case timeInterval = "timeInterval", colorScheme = "colorScheme", autoRefresh = "autoRefresh"
}
class Configuration{
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()
    
    var timeInterval: Double{
        get{
            //recupera uma informação do user default
            return defaults.double(forKey: UserDefaultKeys.timeInterval.rawValue)
        }
        set{
            defaults.set(newValue, forKey: UserDefaultKeys.timeInterval.rawValue)
        }
    }
    
    var colorScheme: Int{
        get{
            //recupera uma informação do user default
            return defaults.integer(forKey: UserDefaultKeys.colorScheme.rawValue)
        }
        set{
            defaults.set(newValue, forKey: UserDefaultKeys.colorScheme.rawValue)
        }
    }
    
    var autoRefresh: Bool{
        get{
            //recupera uma informação do user default
            return defaults.bool(forKey: UserDefaultKeys.autoRefresh.rawValue)
        }
        set{
            defaults.set(newValue, forKey: UserDefaultKeys.autoRefresh.rawValue)
        }
    }
    
    private init(){
        if defaults.double(forKey: UserDefaultKeys.timeInterval.rawValue) == 0 {
            defaults.set(8.0, forKey: UserDefaultKeys.timeInterval.rawValue)
        }
    }
}
