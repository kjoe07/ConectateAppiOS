//
//  NetworkLoader.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/16/20.
//  Copyright © 2020 Yoel Jimenez del Valle. All rights reserved.
//

import Foundation
class NetworkLoader{
     static func loadData<T: Codable>(url: String,data: [String: Any?],method: Method ,completion: @escaping (MyResult<T>) -> Void) {
        var request: URLRequest!
        if method == .get{
            var components = URLComponents(string: url)!
            components.queryItems = data.map { (key, value) in
                    return URLQueryItem(name: key, value: String(describing: value ?? ""))
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)//replacingOccurrences(of: "+", with: "%2B")
            request = URLRequest(url: components.url!)
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
        //request.
        if let str = KeychainService.loadPassword(service: "cuauhtemoc", account: "token"){
            print("the request token: \(str):",url)
            print("contains:",url.contains("registrar"))
            print("contains:",url.contains("verificarCodigo"))
            print("contains:",url.contains("login"))
            print("the if clause:",!(url.contains("registrar")) || !(url.contains("verificarCodigo")) || !(url.contains("login")))
            if !(url.contains("registrar")) && !(url.contains("Codigo")) && !(url.contains("login")) {
                print("added token")
                request.setValue("Token \(str)", forHTTPHeaderField: "Authorization")
            }
        }
//        if method.self == .post{
//
//        }
        let delegate = Delegate()
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue:  .main)
        session.dataTask(with: request){ data,response,error  in
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
                completion(.failure(error))
            }
        }.resume()
        
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
    var method: String{
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
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
