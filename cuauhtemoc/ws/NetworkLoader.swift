//
//  NetworkLoader.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/16/20.
//  Copyright © 2020 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
class NetworkLoader{
    static var task: URLSessionDataTask?
    static func loadData<T: Codable>(url: String,data: [String: Any?],method: Method ,completion: @escaping (MyResult<T>) -> Void) {
        var request: URLRequest!
        if method == .get{
            var components = URLComponents(string: url)!
            if data.count > 0{
                components.queryItems = data.map { (key, value) in
                        return URLQueryItem(name: key, value: String(describing: value ?? ""))
                }
                components.percentEncodedQuery = components.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)//replacingOccurrences(of: "+", with: "%2B")
                request = URLRequest(url: components.url!)
            }else{
                request = URLRequest(url: URL(string: url)!)
            }
            
        }else{
            request = URLRequest(url: URL(string: url)!)
            let jsonDict = data
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
            request.httpBody = jsonData
            print("the post request url is: \(url), \(request.allHTTPHeaderFields?.description ?? "")")
        }
        
        print("the url is \(String(describing: request.url?.absoluteURL))")
        request.httpMethod = method.method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let str = KeychainService.loadPassword(service: "cuauhtemoc", account: "token"){
            if !(url.contains("registrar")) && !(url.contains("Codigo")) && !(url.contains("login")) {
                print("added token")
                request.setValue("Token \(str)", forHTTPHeaderField: "Authorization")
            }
        }
        let delegate = Delegate()
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue:  .main)
        task = session.dataTask(with: request){ data,response,error  in
//        URLSession.shared.dataTask(with: request){ data,response,error  in
            print("response \(String(describing: response)): \(String(describing: data))")
            if error != nil {
                completion(.failure(error!))
            }
            guard let data = data else { return }
            do{
                let value = try JSONDecoder().decode(T.self, from: data)
                completion(.success(dat: value))
            }catch{
                if (response as? HTTPURLResponse)?.statusCode == 204{
                    let val = Noresponse(value: true)
                    let data = try? JSONEncoder().encode(val)
                    let value = try? JSONDecoder().decode(T.self, from: data!)
                    completion(.success(dat: value!))
                }else{
                     completion(.failure(error))
                }               
            }
        }//.resume()
        task?.resume()
    }
    static func sendPostFormData<T:Codable>(formFields: [String: String]?,url: String, imageData: Data?,completion: @escaping (MyResult<T>) -> Void){
            let boundary = "Boundary-\(UUID().uuidString)"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if let str = KeychainService.loadPassword(service: "cuauhtemoc", account: "token"){
                print("the request token: \(str)")
                request.setValue("Token \(str)", forHTTPHeaderField: "Authorization")
               //request.setValue(str, forHTTPHeaderField: "Authorization")
            }
            let httpBody = NSMutableData()
            if let form = formFields{
                for (key, value) in form {
                  httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
                }
            }
            if let image = imageData{
               httpBody.append(convertFileData(fieldName: "valor",fileName: "pic.jpg",mimeType: "image/png",fileData: image,using: boundary))
            }
            httpBody.appendString("--\(boundary)--")
            request.httpBody = httpBody as Data
            let delegate = Delegate()
            //  let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue:  .main)
            session.dataTask(with: request){ data,response,error  in
            //URLSession.shared.dataTask(with: request) { data, response, error in
                print("response \(String(describing: response)): \(String(describing: data)): \(String(describing: error))")
                guard let data = data else { return }
                do {
                    let decoder = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(dat: decoder))
                } catch{
                    completion(.failure(error))
                }
            }.resume()
        }
    static func cancel(){
        task?.cancel()
    }
    
}
func convertFormField(named name: String, value: String, using boundary: String) -> String {
  var fieldString = "--\(boundary)\r\n"
  fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
  fieldString += "\r\n"
  fieldString += "\(value)\r\n"

  return fieldString
}
func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
  let data = NSMutableData()
  data.appendString("--\(boundary)\r\n")
  data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
  data.appendString("Content-Type: \(mimeType)\r\n\r\n")
  data.append(fileData)
  data.appendString("\r\n")

  return data as Data
}
extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
enum MyResult<T>{
    case success(dat: T)
    case failure(Error)
}

enum Method {
    case post
    case get
    case patch
    case put
    case delete
    var method: String{
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
class Delegate: NSObject, URLSessionDelegate{
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("delegate call")
//        if challenge.protectionSpace.host == "conectateyempleate.com" {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
//        } else {
//            completionHandler(.performDefaultHandling, nil)
//        }
    }
}
struct Noresponse:Codable{
    var value: Bool
}
