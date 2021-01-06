//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    // MARK: - Properties
    var car: Car!
    var brands: [Brand] = []
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        toolbar.items = [btCancel, btSpace, btDone]
        tfBrand.inputView = pickerView
        tfBrand.inputAccessoryView = toolbar
        
        loadBrands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if car != nil{
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Editar", for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
        
        
        if car == nil{
            car = Car()
        }
        
        car.name = tfName.text!.isEmpty ? "Sem nome": tfName.text!
        car.brand = tfBrand.text!.isEmpty ? "Sem marca" : tfBrand.text! 
        car.price = Double(tfPrice.text!) ?? 0.0
        car.gasType = scGasType.selectedSegmentIndex
     
        if car._id == nil{
            REST.save(car: car) { (success) in
                self.goBack()
            }
        }else{
            REST.update(car: car) { (success) in
              self.goBack()
            }
        }
    }
    
    // MARK - Methods
    @objc func cancelAction(){
        tfBrand.resignFirstResponder()
    }
    
    @objc func doneAction(){
        let index = pickerView.selectedRow(inComponent: 0)
        tfBrand.text = brands[index].fipe_name
        tfBrand.resignFirstResponder()
    }
    
    func goBack(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.loading.stopAnimating()
        }
    }
    
    func loadBrands(){
        REST.loadBrands { (brands) in
            DispatchQueue.main.async {
                if let brands = brands{
                    self.brands = brands.sorted(by: {$0.fipe_name < $1.fipe_name})
                    self.pickerView.reloadAllComponents()
                    
                    
                }
            }
        }
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {        
        return brands[row].fipe_name
    }
    
    
}
