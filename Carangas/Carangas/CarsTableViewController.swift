//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {

    var cars: [Car] = []
    
    var backgroudTableLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = UIColor.init(named: "main")
        
        return lb
    }()
    
    override func viewDidLoad() {
        backgroudTableLabel.text = "Carregando carros..."
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        REST.loadCars(onComplete: { (cars) in
            self.cars = cars
            
            /*
             Quando se cria uma nova tarefa, ela será executada em uma outra
             thread que é criada. DispatchQueue.main.async faz com que o resultado
             dessa thread seja executado na thread principal onde ficam os
             componentes visuais.
             */
            DispatchQueue.main.async {
                self.backgroudTableLabel.text = "Não existe carros cadastrados."
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = cars.count == 0 ? backgroudTableLabel : nil
        return cars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand

        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue . identifier == "viewSegue"{
            let vc = segue.destination as! CarViewController
            let index = tableView.indexPathForSelectedRow!.row
            vc.car = cars[index]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let car = cars[indexPath.row]
            
            REST.delete(car: car) { (success) in
                if success {
                    self.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}
