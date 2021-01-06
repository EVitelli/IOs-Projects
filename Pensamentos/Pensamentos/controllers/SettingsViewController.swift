//
//  SettingsViewController.swift
//  Pensamentos
//
//  Created by Erik Vitelli on 13/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var swAutoRefresh: UISwitch!
    @IBOutlet weak var slTimeInterval: UISlider!
    @IBOutlet weak var scColorScheme: UISegmentedControl!
    @IBOutlet weak var lbTimeInteval: UILabel!
    
    let config = Configuration.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refreh"), object: nil, queue: nil) { (Notification) in
            self.formatView()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
    }
    
    @IBAction func changeAutoRefresh(_ sender: UISwitch) {
        config.autoRefresh = sender.isOn
    }
    
    @IBAction func changeTimeInterval(_ sender: UISlider) {
        let value = Double(round(sender.value))
        changeTimeIntervalLabel(with: value)
        config.timeInterval = value
    }
    
    @IBAction func changeColorScheme(_ sender: UISegmentedControl) {
        config.colorScheme = sender.selectedSegmentIndex
    }
    
    func formatView(){
        swAutoRefresh.setOn(config.autoRefresh, animated: false)
        slTimeInterval.setValue(Float(config.timeInterval), animated: false)
        scColorScheme.selectedSegmentIndex = config.colorScheme
        changeTimeIntervalLabel(with: config.timeInterval)
    }
    
    func changeTimeIntervalLabel(with value: Double){
        lbTimeInteval.text = "Mudar após \(Int(value)) segundos"
    }

}
