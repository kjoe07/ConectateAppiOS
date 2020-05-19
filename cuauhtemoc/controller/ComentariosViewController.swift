//
//  ComentariosViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ComentariosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtComentarios: UITextField!
    
    var post:Post!
    
    var acciones:[Accion]!  = []
    var comentarios:[Accion]!  = []
    var postCompleto:PostCompleto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.txtComentarios.delegate = self

        cargarDatos()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnEnviarMensaje(_ sender: Any) {
        
        if(txtComentarios.text!.isEmpty){
            self.showAlert(title: "¡Ups!", message: "Escribe tu comentario para continuar")
           } else {
           self.wsAccion(tipo: "3",post: self.post.id ?? 0,cuerpo: txtComentarios.text!)
        }
    }
    
    
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        let params = ["tipo":tipo,"post":post,"cuerpo":cuerpo] as [String : Any]
        NetworkLoader.loadData(url: Api.contentAction.url, data: params, method: .post, completion: { [weak self ] (result: MyResult<Accion>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    if data.id ?? 0 > 0{
                        self.comentarios.append(data)
//                        self.comentarios.append(Accion(id: data.id ?? 0, tipo: data.tipo ?? 0, post: data.post ?? 0, cuerpo: data.cuerpo ?? "", estatus: data.estatus ?? 0, nombre_usuario: data.usuario?.nombre ?? "", nombre_post: data.nombre_post ?? "", titulo_post: data.titulo_post ?? "", fecha: data.fecha ?? "", calificacion: Int(data.calificacion ?? "0") ?? 0))
                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
            
        })
        print(params)
        
//        DispatchQueue.main.async {
//            ws.wsToken(params: params, ws: "/contenido/acciones/add", method: "POST", completion: { data in
//
//                let id = data.object(forKey: "id") as! Int
//                let tipo = data.object(forKey: "tipo") as! Int
//                let post = data.object(forKey: "post") as! Int
//                let cuerpo = data.object(forKey: "cuerpo") as! String
//                let estatus = data.object(forKey: "estatus") as! Int
//
//                let nombre_usuario = data.object(forKey: "nombre_usuario") as! String
//                let nombre_post = data.object(forKey: "nombre_post") as! String
//                let titulo_post = data.object(forKey: "titulo_post") as! String
//                let fecha = data.object(forKey: "fecha") as! String
//
//                self.comentarios.append(Accion(id: id, tipo: tipo, post: post, cuerpo: cuerpo, estatus: estatus, nombre_usuario: nombre_usuario, nombre_post: nombre_post, titulo_post: titulo_post, fecha: fecha, calificacion: 0))
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            })
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comentariosTableViewCell", for: indexPath) as! ComentariosTableViewCell
        
        cell.txtNombreUsuario.text = "\(self.comentarios[indexPath.row].usuario?.nombre ?? "") \(self.comentarios[indexPath.row].usuario?.apellido ?? "")"
        
        cell.txtComentario.text = self.comentarios[indexPath.row].cuerpo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comentarios.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func cargarDatos(){
        NetworkLoader.loadData(url: "\(Api.singleContent.url)\(post.id ?? 0)/", data: [:], method: .get, completion: {
            [weak self] (result: MyResult<PostCompleto>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    if data.acciones.count > 0{
                        self.comentarios = data.acciones.filter({
                            $0.tipo == 3
                        })
                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
        
//        let ws = WebServiceClient()
//
//        DispatchQueue.main.async {
//            ws.wsTokenArray(params: "", ws: "/contenido/ver_post/\(self.post.id!)/", method: "GET", completion: { data in
//
//                do {
//                    self.postCompleto = try JSONDecoder().decode(PostCompleto.self, from: data as! Data)
//                    self.acciones.append(contentsOf: self.postCompleto.acciones)
//
//                    for i in 0...self.acciones.count-1 {
//                        if self.acciones[i].tipo == 3 {
//                            self.comentarios.append(self.acciones[i])
//                        }
//                    }
//                    print(self.comentarios.count)
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                } catch let jsonError {
//                    print(jsonError)
//                }
//            })
//        }
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
