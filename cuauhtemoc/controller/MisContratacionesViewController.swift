//
//  MisContratacionesViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class MisContratacionesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var contenido:ContenidoCompleto!
    var dato:[Contenido]! = []
    var trueques = true
    var userId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        guard let userData = UserDefaults.standard.object(forKey: "usuario") as? Data else {return}
        let user = try? JSONDecoder().decode(Usuario.self, from: userData)
        userId = user?.id
        cargarDatosPost()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contratacionesTableViewCell", for: indexPath) as! ContratacionesTableViewCell
        cell.txtTitulo.text = self.dato[indexPath.row].titulo
        cell.txtContenido.text = self.dato[indexPath.row].body
        cell.txtNombre.text = self.dato[indexPath.row].usuario?.nombre
        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(self.chat(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dato.count
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cargarDatosPost(){
        let params = ["page_size":30,"usuario":userId,"tipo":trueques ? 4 : 5]
        showActivityIndicator(color: UIColor(named: "green") ?? .green)
        NetworkLoader.loadData(url: trueques ? Api.listContent.url : Api.contentAction.url, data: params , method: .get, completion: {[weak self] (result: MyResult<ContentResponse>)in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(let data):
                    if data.count ?? 0 > 0{
                        self.dato = data.results ?? [Contenido]()
                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }            
        })
    }
    @IBAction func chat(_ sender: UIButton){
        DispatchQueue.main.async {
            let urlWhats = "whatsapp://send?phone=+\(self.dato[sender.tag].usuario?.celular ?? "")&text=Hola\(self.dato[sender.tag].usuario?.nombre ?? "") \(self.dato[sender.tag].usuario?.apellido ?? "") estoy interesado \(self.trueques ? "realizar trueque de" : "comprar") \(self.dato[sender.tag].titulo ?? "")"
            var characterSet = CharacterSet.urlQueryAllowed
             characterSet.insert(charactersIn: "?&")
             if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet){
                 if let whatsappURL = URL(string: urlString) {
                   if UIApplication.shared.canOpenURL(whatsappURL as URL){
                        UIApplication.shared.open(whatsappURL)
                   }else {
                       print("Install Whatsapp")
                   }
                }
            }
        }
    }
}
