//
//  ResultViewController.swift
//  SwiftQuiz
//
//  Created by Erik Vitelli on 22/04/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var lbAnswered: UILabel!
    @IBOutlet weak var lbCorrect: UILabel!
    @IBOutlet weak var lbWrong: UILabel!
    @IBOutlet weak var lbPercent: UILabel!
    
    
    var totalCorrectAnswers : Int = 0
    var totalAnswers : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbAnswered.text =  "Perguntas repondidas: \(totalAnswers)"
        lbCorrect.text =  "Perguntas corretas: \(totalCorrectAnswers)"
        lbWrong.text =  "Perguntas erradas: \(totalAnswers - totalCorrectAnswers)"
        lbPercent.text = "\(totalCorrectAnswers*100/totalAnswers)%"
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
