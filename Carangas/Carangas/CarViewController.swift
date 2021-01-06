//
//  CarViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//
import Foundation
import UIKit
import  WebKit

class CarViewController: UIViewController {

    var car: Car!
    
    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if car != nil{
            title = car.name
            lbBrand.text  = car.brand
            lbGasType.text = car.gas
            lbPrice.text = "R$ \(car.price)"
        }
        
        guard let title = title else{return}
        
        let name = (title + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let urlStr = "https://www.google.com.br/search?q=\(name)&tbm=isch"
        let url = URL(string: urlStr)!
        
        let request = URLRequest(url: url)
        
        // Indica se eu posso utilizar os swip da esuquerda e direita pra navegar entre páginas
        webView.allowsBackForwardNavigationGestures = true
        
        // Consigo pré visualizar um link somente pressionando-o com mais força
        webView.allowsLinkPreview = true
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = car
    }

}

extension CarViewController: WKNavigationDelegate, WKUIDelegate{
    //sempre que terminar o carregamento de uma página esse método é chamado
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
