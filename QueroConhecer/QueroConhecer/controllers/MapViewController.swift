
//
//  MapViewController.swift
//  QueroConhecer
//
//  Created by Erik Vitelli on 21/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit
import MapKit

enum MapMessageType{
    case routeError, authorizationWarning
}

class MapViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var places : [Place] = []
    var pointsOfInterest: [MKAnnotation] = []
    var btUserLocation: MKUserTrackingButton!
    var selectedAnnotation: PlaceAnnotation?
    
    // Lazy: diz que a variável só vai ser instanciada no momento em que ela for usada
    lazy var locationManeger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.isHidden = true
        viewInfo.isHidden = true
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        locationManeger.delegate = self

        title = places.count == 1 ? places[0].name : "Meus Lugares"
        
        for place in places {
            addToMap(place)
        }
        
        configureLocationButton()
        showPlaces()
        // Faz um requisição da autorização de localização do usuário
        requestUserLocationAuthorization()
    }
    
    // Gera a rota no mapa
    @IBAction func showRoute(_ sender: UIButton) {
        // Verifica se o usuário deu a permissão de localização
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            showMessage(type: .authorizationWarning)
            return
        }
        
        let request = MKDirections.Request()
        // Seta o destino do usuário a parti da annotation selecionada
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedAnnotation!.coordinate))
        // Seta a origem do usuário
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManeger.location!.coordinate))
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            if error == nil{
                if let response = response{
                    // Overlay são camadas do mapa
                    // Remove os overlays do mapa
                    self.mapView.removeOverlays(self.mapView!.overlays)
                    
                    let route = response.routes.first!
                  
                    // adicionar um overlay no mapa que no caso é a linha da rota
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    
                    // Remove todas as annotations que não são a do usuário
                    var annotations = self.mapView.annotations.filter({!($0 is PlaceAnnotation)})
                    // Adiciona a annotation de destino no array
                    annotations.append(self.selectedAnnotation!)
                    // Mostras as annotations no mapa usando as do array
                    self.mapView.showAnnotations(annotations, animated: true)
                }
            }else{
                self.showMessage(type: .routeError)
            }
        }
    }
    
    @IBAction func showSeachBar(_ sender: UIBarButtonItem) {
        searchBar.resignFirstResponder()
        searchBar.isHidden = !searchBar.isHidden
    }
    
    func addToMap(_ place: Place){
        // Annotation são os pins colocados nos mapas
        let annotation = PlaceAnnotation(coordinate: place.coordinate, type: .place)
        annotation.title = place.name
        annotation.address = place.address
        mapView.addAnnotation(annotation)
    }
    
    func configureLocationButton(){
        // Cria uma instancia do botão passando como parametro o mapa que será vinculado
        btUserLocation = MKUserTrackingButton(mapView: mapView)
        btUserLocation.backgroundColor = .white
        btUserLocation.frame.origin.x = 10
        btUserLocation.frame.origin.y = 10
        btUserLocation.layer.cornerRadius = 5.0
        btUserLocation.layer.borderWidth = 1.0
        btUserLocation.layer.borderColor = UIColor(named: "main")?.cgColor
    }
    
    func requestUserLocationAuthorization(){
        // Verifica se os serviços de localização estão disponíveis
        /*
         CLLocationManager
         Fornece um objeto capaz de gerenciar a localização do usuário
         */
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways , .authorizedWhenInUse:
                // Mostra o botão de localização no mapa
                mapView.addSubview(btUserLocation)
            case .denied:
                // Chamado qunado o usuário nega a autorização
                showMessage(type: .authorizationWarning)
            case.notDetermined:
                // Chamado se o usuário nunca viu a tela
                locationManeger.requestWhenInUseAuthorization()
            case .restricted:
                break
            }
        }else{
            // Usuário não tem os serviço de localização habilitado
            return
        }
    }
    
    func showInfo(){
        lbName.text = selectedAnnotation?.title
        lbAddress.text = selectedAnnotation?.address
        viewInfo.isHidden = false
    }
    
    func showPlaces(){
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func showMessage(type: MapMessageType){
        let title = type == .authorizationWarning ? "Aviso":"Erro"
        let message = type == .authorizationWarning ? "Para usar os recursos de localização do app, você precisa permitir o uso na tela de Ajuste do app." : "Não foi possível encontrar está rota."
   
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
        
        if type == .authorizationWarning{
            // Caso o usuário confirme ele é direcionado para a página de ajustes do app
            let confirmAction = UIAlertAction(title: "Ir para ajustes", style: .default, handler: { (action) in
                
                    if let appSettings = URL(string: UIApplication.openSettingsURLString){
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
            })
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation){
            return nil
        }
        
        let type = (annotation as! PlaceAnnotation).type
        let identifier = "\(type)"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        // Seta a cor da annotation
        annotationView?.markerTintColor = type == .place ? UIColor(named: "main") : UIColor(named: "poi")
        
        // Seta a imagem da annotation
        annotationView?.glyphImage = type == .place ? UIImage(named: "placeGlyph") : UIImage(named: "poiGlyph")
        // Seta a prioridade de visualização da annotation
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        
        return annotationView
    }
    
    // Chamado toda vez que o usuário seleciona um annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let camera = MKMapCamera()
        
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80
        camera.altitude = 100
        mapView.setCamera(camera, animated: true)
        
        // Recupera a annotation do objeto view
        selectedAnnotation = view.annotation as! PlaceAnnotation
        showInfo()
    }
    // reindeniza o overlay no mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "main")?.withAlphaComponent(0.8)
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MapViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        // Remove o foco da searchBar fazendo o teclado sumir
        searchBar.resignFirstResponder()
        loading.startAnimating()
        
        //Pesquisa os pontos de interesses digitados pelo usuário
        let request = MKLocalSearch.Request()
        
        /*
         naturalLanguageQuery
         
         É uma pesquisa de linguagem natural, busca o que o usuário está pesquisando mas não em sentido literal.
         Por exemplo, se o usuário pesquisar "Café", ele não vai buscar a definição de café mas sim cafeterias. Se pesquisar "Filme" busca cinema, etc.
         */
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil{
                guard let response = response else {
                    self.loading.stopAnimating()
                    return
                }
                self.mapView.removeAnnotations(self.pointsOfInterest)
                self.pointsOfInterest.removeAll()
                
                for place in response.mapItems{
                    let annotation = PlaceAnnotation(coordinate: place.placemark.coordinate, type: .pointOfInterest)
                    annotation.title = place.name
                    annotation.subtitle = place.phoneNumber
                    annotation.address = Place.getFormattedAddress(with: place.placemark)
                    self.pointsOfInterest.append(annotation)
                }
            self.mapView.addAnnotations(self.pointsOfInterest)
            self.mapView.showAnnotations(self.pointsOfInterest, animated: true)
            }
            self.loading.stopAnimating()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Chamado quando o usuário modifica o status da autorização de localização
        
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.addSubview(btUserLocation)
            // Atualiza a localização do usuário
            locationManeger.startUpdatingLocation()
        default:
            break
        }
    }
    
    // Chamado toda vez que o usuário atualiza a localização
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)
    }
}
