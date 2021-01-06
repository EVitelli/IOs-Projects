//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Erik Vitelli on 21/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit
import MapKit
protocol PlaceFinderDelegate: class {
    func addPlace(_ place: Place)
}

enum placeFinderMessageType{
    case error(String), confirmation(String)
}

class PlaceFinderViewController: UIViewController {

    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView!
    
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)

    }
    
    @IBAction func findCity(_ sender: Any) {
        txtCity.resignFirstResponder()
        let address = txtCity.text!
        
        load(show: true)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.load(show: false)
            if error == nil{
                if !self.savePlace(with: placemarks?.first){
                    self.showMessage(type: .error("Nenhum local encontrado com este nome."))
                }else{
                    print("ok")
                }
            }else{
                self.showMessage(type: .error("Erro desconhecido"))
            }
            
            
        }
    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began{
            load(show: true)
            
            // Recupera o local que o usuário tocou no mapa
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                self.load(show: false)
                if error == nil{
                    if !self.savePlace(with: placemarks?.first){
                        self.showMessage(type: .error("Nenhum local encontrado com este nome."))
                    }else{
                        print("ok")
                    }
                }else{
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            }
            
        }
    }
    
    func savePlace (with placemark: CLPlacemark?)->Bool{
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {
            return false
        }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        // Coloca o pin no mapa de acordo com o endereço digitado pelo usuário
        /*
         É preciso criar uma região passando a coordenada gerada na busca pelo usuário e passar quanto metros em latitude e longitude eu vou visualizar de mapa na minha tela.
         */
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.setRegion(region, animated: true)
        
        showMessage(type: .confirmation(place.name))
        
        return true
    }
    
    func showMessage(type: placeFinderMessageType){
        let title: String, message: String
        var hasConfirmation = false
        
        switch type {
        case .confirmation(let place):
            title = "Local encontrado"
            message = "Deseja adicionar \(place)"
            hasConfirmation = true
        case .error(let errorMessage):
            title = "Erro"
            message = errorMessage
        }
        
        // Criando um alert control
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation{
            let confirmAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                
                self.delegate?.addPlace(self.place)
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(confirmAction)
        }
        
        // Mostra o alert na tela para o usuário
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func load(show: Bool){
        viewLoading.isHidden = !show
        
        if show{
            aiLoading.startAnimating()
        }else{
            aiLoading.stopAnimating()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
