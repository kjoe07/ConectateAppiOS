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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        cargarDatosPost()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contratacionesTableViewCell", for: indexPath) as! ContratacionesTableViewCell
        
        cell.txtTitulo.text = self.dato[indexPath.row].titulo
        cell.txtContenido.text = self.dato[indexPath.row].body
        cell.txtNombre.text = self.dato[indexPath.row].usuario.nombre
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dato.count
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cargarDatosPost(){
        
        let ws = WebServiceClient()
        let pref = UserDefaults();
        print("/contenido/list_post/?page_size=30&usuario=\(pref.value(forKey: "idUsuario")!)")
        
        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/contenido/list_post/?page_size=30&usuario=\(pref.value(forKey: "idUsuario")!)", method: "GET", completion: { data in
                
                do {
                    self.contenido = try JSONDecoder().decode(ContenidoCompleto.self, from: data as! Data)
                    self.dato.append(contentsOf: self.contenido.results)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
}
