//
//  ScreenColorViewController.swift
//  Mensagens
//
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class ScreenColorViewController: BaseViewController {
    
    @IBOutlet weak var viBorder: UIView!
    @IBOutlet weak var swWhiteBorder: UISwitch!
    @IBOutlet weak var btChangeViewColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btChangeViewColor.layer.cornerRadius = 8.0
        
        lbMessage?.text = message.text
        lbMessage?.textColor = message.textColor
        lbMessage?.backgroundColor = message.backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultViewController
        
        vc.message = message
        vc.useWhiteBorder = swWhiteBorder.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
   
    
    @IBAction func changeBorder(_ sender: UISwitch) {
        viBorder.backgroundColor = sender.isOn ? .white : .clear
    }
}

extension ScreenColorViewController: colorPickerDelegate{
    func applyColor(color: UIColor) {
        view.backgroundColor = color
        message.screenColor = color
    }
}

