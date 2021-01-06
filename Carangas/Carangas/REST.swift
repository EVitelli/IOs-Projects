//
//  Rest.swift
//  Carangas
//
//  Created by Erik Vitelli on 10/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

enum CarError{
    case url, taskError(error: Error), noResponse, noData
    case responseStatusCode(code: Int), invalidJSON
}

enum RestOperation: String{
    case DELETE = "DELETE",POST = "POST",PUT = "PUT"
}
class REST{
    
    // URL base da api
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    
    private static let configuration: URLSessionConfiguration = {
        /* URLSessionConfiguration
         .default = utiliza as configurações padrões
         faz armazenamento em cache
         
         .ephemeral = cria uma sessão privada, utilizado para modo anonimo
         
         .background = trabalha com requisições quando seu app não está em uso
         */
        let config = URLSessionConfiguration.default
        
        /* Define se o a sessão funciona com o 3/4G do celular caso true, pode ser dado ao jusuário a opção de habilitar ou desabilitar isso
         */
        config.allowsCellularAccess = false
        
        // Configura o cabeçalho das requisições
        config.httpAdditionalHeaders = ["Content-Type":  "application/json"]
        
        // É o tempo em segundos que essa requisição terá até ela ser cancelada
        config.timeoutIntervalForRequest = 30.0
        
        // Qauntide de requisições utilizando essa sessão ao mesmo tempo
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    // Cria juma sessão para poder acessar a api
    private static let session = URLSession(configuration: configuration)
    
    /*
     Responsável por recuperar os dados do servidor
     Retorna os dados para serem utilizados em forma de closure
     
     @escaping
        Quando um método é chamado e ele contem paramêtro, esses parametros só
        existem até o fim desse método. Quando o método termina, o atributo é
        retirado da memória dando fim a ele.
        O @escaping diz para meu compilador manter esse parametros mesmo quando
        o método tiver seu fim possibilitando que o atributo seja utilizado depois.
     */
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void){
        // Cria uma url
        guard let url = URL(string: basePath) else{
            onError(CarError.url)
            return
        }
        /*
         Cria uma tarefa para solicitação de dados porém não a executa
         
         with: url - Usado quando se quer fazer um get
         */
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            // Verifica se o app não retornou nenhum erro
            if error == nil{
                // Desembrulha o response para poder ser utilizado
                guard let response = response as? HTTPURLResponse else{
                    onError(CarError.noResponse)
                    return
                }
                // Verifca se o server retornou o status de ok
                if response.statusCode == 200{
                    // Desembrulha os dados retornados pelo server
                    guard let data = data else{return}
                    // Converte os dados recebidos em um array de car
                    do{
                        let cars: [Car] = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                    }catch{
                        print(error.localizedDescription)
                        onError(CarError.invalidJSON)
                    }
                }else{
                    onError(CarError.responseStatusCode(code: response.statusCode))
                }
            }else{
                print(error!.localizedDescription)
                onError(CarError.taskError(error: error!))
            }
        }
        // Executa a task criada
        dataTask.resume()
    }
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void){
        // URL onde se encontra todas as marcas de veiculos
        let urlFipeTable = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
        guard let url = URL(string: urlFipeTable) else{
            onComplete(nil)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else{
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200{
                    guard let data = data else{return}
                    do{
                        let brands: [Brand] = try JSONDecoder().decode([Brand].self, from: data)
                        onComplete(brands)
                    }catch{
                        print(error.localizedDescription)
                        onComplete(nil)                    }
                }else{
                    onComplete(nil)
                }
            }else{
                print(error!.localizedDescription)
                onComplete(nil)
            }
        }
        // Executa a task criada
        dataTask.resume()
    }
    
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void){
        applyOperation(car: car, operation: .POST, onComplete: onComplete)
    }
    
    /*
     Para o método de editar, se utiliza a mesma estrutura do adicionar, só é
     necessário fazer alguns ajuste que são:
     - Alterar a url que será passada para o requeste adicionando o id do objeto
     - Alterar o httpMethod para PUT
     */
    class func update(car: Car, onComplete: @escaping (Bool) -> Void){
        applyOperation(car: car, operation: .PUT, onComplete: onComplete)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void){
        applyOperation(car: car, operation: .DELETE, onComplete: onComplete)
        
    }
    
    private class func applyOperation(car: Car, operation: RestOperation, onComplete: @escaping (Bool) -> Void){
        
        let URLString = basePath + "/" + (car._id ?? "")
        
        // Cria uma url
        guard let url = URL(string: "\(URLString)") else{
            onComplete(false)
            return
        }
        
        // Cria uma url request
        var request = URLRequest(url: url)
        // Informa pra url qual será o método utilizado
        request.httpMethod = operation.rawValue
        
        /*
         Cria um JSON do objeto
         
         retorna ou o objeto desejado ou nulo
         */
        guard let json = try? JSONEncoder().encode(car) else{
            onComplete(false)
            return
        }
        
        // Adiciona o json no body do request
        request.httpBody =  json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else{
                    onComplete(false)
                    return
                }
                
                onComplete(true)
                
            }else{
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
