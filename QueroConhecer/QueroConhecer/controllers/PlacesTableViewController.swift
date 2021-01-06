//
//  PlacesTableViewTableViewController.swift
//  QueroConhecer
//
//  Created by Erik Vitelli on 21/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit



class PlacesTableViewController: UITableViewController {

    var places: [Place] = []
    
    var lbNoPlaces: UILabel!
    
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbNoPlaces = UILabel()
        lbNoPlaces.text = "Cadastre os locais que deseja conhecer clicando no botão \"+\" acima."
        lbNoPlaces.textAlignment = .center
        lbNoPlaces.numberOfLines = 0
        loadPlaces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! != "mapSegue"{
            let vc = segue.destination as! PlaceFinderViewController
            vc.delegate = self
        }else{
            let vc = segue.destination as! MapViewController
            
            switch sender{
                case let place as Place:
                    vc.places = [place]
                default:
                    vc.places = places
                
            }
            
        }
    }

    func loadPlaces(){
        if let placesData = userDefault.data(forKey: "places"){
            do{
                places = try JSONDecoder().decode([Place].self, from: placesData)
                tableView.reloadData()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func savePlaces(){
        let json = try? JSONEncoder().encode(places)
        userDefault.set(json, forKey: "places")
    }
    
    @objc func showAll(){
        performSegue(withIdentifier: "mapSegue", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0 {
            let btShowAll = UIBarButtonItem(title: "Mostrar todos", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btShowAll
            tableView.backgroundView = nil
        }else{
            navigationItem.leftBarButtonItem = nil
            tableView.backgroundView = lbNoPlaces
        }
        
        
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let place = places[indexPath.row]
        cell.textLabel?.text = place.name
        
        return cell
    }
    
    // Chamado quando o usuário clica em uma célula da view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place =  places[indexPath.row]
        performSegue(withIdentifier: "mapSegue", sender: place)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savePlaces()
        }
    }
}

extension PlacesTableViewController: PlaceFinderDelegate{
    func addPlace(_ place: Place) {
        if !places.contains(place){
            places.append(place)
            savePlaces()
            tableView.reloadData()
        }
    }
}

