//
//  WebServiceClient.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/14/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class WebServiceClient:NSObject{
    let strings = Strings()

    func login(mail:String, pass:String, googleId:String, completion:@escaping (AnyObject) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(strings.ws)/usuarios/login/")! as URL)
        request.httpMethod = "POST"
        let postString = "email=\(mail)&password=\(pass)&googleid=\(googleId)&dispositivo=\(strings.dispositivo)&interfaz=\(Strings.interfaz)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error?.localizedDescription ?? "")")
                completion("error" as AnyObject)
                return
            }
            
            if data != nil {
                DispatchQueue.global().async {
                    DispatchQueue.main.async(){
                        //print(self.dataToJSON(data!)!)
                        completion(self.dataToJSON(data!)!)
                    }
                }
            }
        }
        task.resume()
    }

    func registro(mail:String, pass:String, nombre:String, apellido:String, celular:String, fecha:String,cp:String,   googleId:String, completion:@escaping (AnyObject) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(strings.ws)/usuarios/registrar/")! as URL)
        request.httpMethod = "POST"
        let postString = "email=\(mail)&password=\(pass)&nombre=\(nombre)&apellido=\(apellido)&celular=\(celular)&fecha_nacimiento=\(fecha)&cp=\(cp)&googleid=\(googleId)&dispositivo=\(strings.dispositivo)&interfaz=\(Strings.interfaz)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        print(postString)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error?.localizedDescription ?? "")")
                completion("error" as AnyObject)
                return
            }
            
            if data != nil {
                DispatchQueue.global().async {
                    DispatchQueue.main.async(){
                        //print(self.dataToJSON(data!)!)
                        completion(self.dataToJSON(data!)!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func wsGenericoPost(params:String, ws:String, method:String, completion:@escaping (AnyObject) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(strings.ws)\(ws)")! as URL)
        request.httpMethod = method
        let postString = params
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        print(postString)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error?.localizedDescription ?? "")")
                completion("error" as AnyObject)
                return
            }
            
            if data != nil {
                DispatchQueue.global().async {
                    DispatchQueue.main.async(){
                        //print(self.dataToJSON(data!)!)
                        completion(self.dataToJSON(data!)!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func wsToken(params:String, ws:String, method:String, completion:@escaping (AnyObject) -> Void) {
        let pref = UserDefaults.standard
        let request = NSMutableURLRequest(url: NSURL(string: "\(strings.ws)\(ws)")! as URL)
        request.addValue("Token \(pref.string(forKey: "token")!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = method
        let postString = params
        request.httpBody = postString.data(using: String.Encoding.utf8)
        print(postString)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error?.localizedDescription ?? "")")
                completion("error" as AnyObject)
                return
            }
            
            if data != nil {
                DispatchQueue.global().async {
                    DispatchQueue.main.async(){
                        print(self.dataToJSON(data!)!)
                        completion(self.dataToJSON(data!)!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func wsTokenArray(params:String, ws:String, method:String, completion:@escaping (AnyObject) -> Void) {
       // let pref = UserDefaults.standard
        let request = NSMutableURLRequest(url: NSURL(string: "\(strings.ws)\(ws)")! as URL)
        //request.addValue("Token \(pref.string(forKey: "token")!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = method
        let postString = params
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error?.localizedDescription ?? "")")
                completion("error" as AnyObject)
                return
            }
            
            if data != nil {
                DispatchQueue.global().async {
                    DispatchQueue.main.async(){
//                        print(self.dataToJSON(data!)!)
                        completion((data! as AnyObject))
                    }
                }
            }
        }
        task.resume()
    }

    func dataToJSON(_ data: Data) -> NSDictionary? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
        } catch let myJSONError {
            print("Error: \(myJSONError)")
        }
        return nil
    }

}
