//
//  QuotesViewController.swift
//  Pensamentos
//
//  Created by Erik Vitelli on 13/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var imgPhotoBG: UIImageView!
    @IBOutlet weak var lbQuote: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lcTop: NSLayoutConstraint!
    
    let quotesManeger = QuotesManeger()
    let config = Configuration.shared
    
    var timer: Timer?
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareQuote()
    }
    
    func formatView(){
        if config.colorScheme == 0{
            view.backgroundColor = .white
            lbQuote.textColor = .black
            lbAuthor.textColor = UIColor(red: 192.0/255.0, green: 96.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        }else{
            view.backgroundColor = UIColor(red: 156.0/255.0, green: 68.0/255.0, blue: 15.0/255.0, alpha: 1.0)
            lbQuote.textColor = .white
            lbAuthor.textColor = .yellow
        }
        
        prepareQuote()
    }
    
    func prepareQuote(){
        // Invalida os agendamentos já iniciados
        timer?.invalidate()
        
        if config.autoRefresh{
            /*
             Agendamento de uma ação, recebe o intervalo de tempo em Double, um bool
            para dizer se repete ou nao e um closure que é a ação que será realizada
             */
            timer = Timer.scheduledTimer(withTimeInterval: config.timeInterval, repeats: true) { (timer) in
                self.showRandomQuote()
            }
        }
        showRandomQuote()
    
    }
    
    func showRandomQuote(){
        let quote = quotesManeger.getRandonQuote()
        lbQuote.text = quote.quote
        lbAuthor.text = quote.author
        
        let image = UIImage(named: quote.image)
        imgPhoto.image = image
        imgPhotoBG.image = image
        
        lbQuote.alpha = 0.0
        lbAuthor.alpha = 0.0
        imgPhoto.alpha = 0.0
        imgPhotoBG.alpha = 0.0
        lcTop.constant = 50
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.5) {
            self.lbQuote.alpha = 1.0
            self.lbAuthor.alpha = 1.0
            self.imgPhoto.alpha = 1.0
            self.imgPhotoBG.alpha = 0.25
            self.lcTop.constant = 10
            self.view.layoutIfNeeded()
        }
    }
}
