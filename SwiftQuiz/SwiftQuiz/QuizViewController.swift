//
//  QuizViewController.swift
//  SwiftQuiz
//
//  Created by Erik Vitelli on 22/04/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var viTimer: UIView!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet var btAnswers: [UIButton]!
    
    let quizManager = QuizManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viTimer.frame.size.width = view.frame.size.width
        
        UIView.animate(withDuration: 60.0, delay: 0.0, options: .curveLinear, animations: {
            self.viTimer.frame.size.width = 0.0
        }) { (success) in
            self.showResults()
        }
        
        UIView.animate(withDuration: <#T##TimeInterval#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        
        getNewQuiz()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultViewController
        
        resultVC.totalAnswers = self.quizManager.totalAnswers
        resultVC.totalCorrectAnswers = self.quizManager.totalCorrectAnswers
    }
    
    func getNewQuiz(){
        quizManager.refreshQuiz()
        lbQuestion.text = quizManager.question
        
        for i in 0..<quizManager.options.count{
            let option = quizManager.options[i]
            let button = btAnswers[i]
            button.setTitle(option, for: .normal)
        }
    }
    
    func showResults(){
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        let index = btAnswers.index(of: sender)!
        
        quizManager.validadeAnswer(index: index)
        getNewQuiz()
    }

}
