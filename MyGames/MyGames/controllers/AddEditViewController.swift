//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Erik Vitelli on 31/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var txtCover: UILabel!
    
    /*
        o core data criou a classe Game quanto foi criado
        a entidade Game
     */
    var game: Game!
    var console:  Console!
    var consolesManager = ConsolesManager.shared
    var type: String!
    
    // O Lazy só constroi uma classe quando ela for utilizada
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type != "Console"{
            prepareConsoleTextField()
        }
        load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        //btAddEdit.layer.cornerRadius = 8.0
        
        consolesManager.loadConsoles(with: context)
    }
    
    func load(){
        if type == "Console"{
            btAddEdit.backgroundColor = UIColor(named: "second")
            
            navigationItem.title = "Adicionar console"
            
            txtTitle.placeholder = "Plataforma"
            txtConsole.placeholder = "Desenvolvedor"
            
            if console != nil{
                btAddEdit.setTitle("Editar", for: .normal)
                txtTitle.text = console.name
                txtConsole.text = console.developer ?? ""
                
                if let releaseDate = console.releaseDate{
                    dpReleaseDate.date = releaseDate
                }
            }
            
            btCover.isHidden = true
            imgCover.isHidden = true
            txtCover.isHidden = true
        }else{
            btAddEdit.backgroundColor = UIColor(named: "main")
            
            if game != nil{
                title = "Editar Game"
                btAddEdit.setTitle("Alterar", for: .normal)
                txtTitle.text = game.title
                
                /*
                 Verifica se o console não é nulo, se for
                 verdadeiro ele verifica se o console contém um
                 index
                 */
                if let console = self.game.console,let index = consolesManager.consoles.index(of: console){
                    txtConsole.text = console.name
                    pickerView.selectRow(index, inComponent: 0, animated: true)
                }
                
                imgCover.image =  game.cover as? UIImage
                
                if let releaseDate = game.releaseDate{
                    dpReleaseDate.date = releaseDate
                }
                
                btCover.isHidden = false
                imgCover.isHidden = false
                txtCover .isHidden = false
            }
        }
        
        if imgCover.image != nil{
            btCover.setTitle(nil, for: .normal)
        }
    }
    
    @IBAction func addEditCover(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        // Verifica se o dispositivo tem câmera 
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction =  UIAlertAction(title: "Biblíoteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction =  UIAlertAction(title: "Album de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBAction func addEditGame(_ sender: Any) {
        if type == "Console"{
            let console = self.console ?? Console(context: self.context)
            console.name = txtTitle.text
            console.developer = txtConsole.text
            console.releaseDate = dpReleaseDate.date
            
            do{
                try self.context.save()
            }catch{
                print(error.localizedDescription)
            }
        }else{
            if game == nil{
                //Adicionando
                game = Game(context: context)
            }
            game.title = txtTitle.text
            game.releaseDate = dpReleaseDate.date
            
            if !txtConsole.text!.isEmpty{
                let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
                game.console = console
            }
            
            game.cover = imgCover.image
            
            /*
             Até este momento o jogo só está cadastrado no
             context, abaixo ocorre a persistencia desse context
            */
            do{
               try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }
        
        // Retorna pra tela anterior
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func cancel(){
        txtConsole.resignFirstResponder()
    }
    
    @objc func done(){
        let selectedRowInPicker = pickerView.selectedRow(inComponent: 0)
        
        // Recupera o item selecionado no picker
        txtConsole.text = consolesManager.consoles[selectedRowInPicker].name
        
        
        cancel()
    }
    
    
    
    func selectPicture(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true)
    }
    
    func prepareConsoleTextField(){
        // Cria os botões que serão adicionados a toolbar
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        /*
         Cria um botão com espaçamento flexivel para que o botão done vá para a
         direita
         */
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        /*
         Cria uma toolbar que será adiconada em cima do picker view mostrando
         os botões de cancelar e ok
         */
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolBar.tintColor = UIColor(named: "main")
        toolBar.items = [btCancel, btFlexibleSpace, btDone]
        
        // Define a view de entrada do teclado como sendo o picker view
        txtConsole.inputView = pickerView
        txtConsole.inputAccessoryView = toolBar
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    /*
     - Define quantos componentes vai ter no picker view
     - Componentes é o número do colunas que meu picker view vai ter
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Define o número de linhas de cada componente
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    // Define o título de cada componente
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        
        return console.name
    }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // Chamado ao selecionar uma imagem
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Recupera a imagem que foi selecionada
        let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
