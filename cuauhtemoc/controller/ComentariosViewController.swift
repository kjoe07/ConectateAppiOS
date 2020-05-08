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
            
            enviarMensaje(titulo: "¡Ups!", mensaje: "Escribe tu comentario para continuar")
    
        } else {
            
           self.wsAccion(tipo: "3",post: self.post.id ?? 0,cuerpo: txtComentarios.text!)
        }
    }
    
    
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        
        let ws = WebServiceClient()
        let params = "tipo=\(tipo)&post=\(post)&cuerpo=\(cuerpo)"
        
        print(params)
        
        DispatchQueue.main.async {
            ws.wsToken(params: params, ws: "/contenido/acciones/add", method: "POST", completion: { data in
                
                let id = data.object(forKey: "id") as! Int
                let tipo = data.object(forKey: "tipo") as! Int
                let post = data.object(forKey: "post") as! Int
                let cuerpo = data.object(forKey: "cuerpo") as! String
                let estatus = data.object(forKey: "estatus") as! Int
                
                let nombre_usuario = data.object(forKey: "nombre_usuario") as! String
                let nombre_post = data.object(forKey: "nombre_post") as! String
                let titulo_post = data.object(forKey: "titulo_post") as! String
                let fecha = data.object(forKey: "fecha") as! String

                self.comentarios.append(Accion(id: id, tipo: tipo, post: post, cuerpo: cuerpo, estatus: estatus, nombre_usuario: nombre_usuario, nombre_post: nombre_post, titulo_post: titulo_post, fecha: fecha, calificacion: 0))
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comentariosTableViewCell", for: indexPath) as! ComentariosTableViewCell
        
        cell.txtNombreUsuario.text = self.comentarios[indexPath.row].nombre_usuario
        
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
        
        let ws = WebServiceClient()
        
        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/contenido/ver_post/\(self.post.id!)/", method: "GET", completion: { data in
                
                do {
                    self.postCompleto = try JSONDecoder().decode(PostCompleto.self, from: data as! Data)
                    self.acciones.append(contentsOf: self.postCompleto.acciones)
                    
                    for i in 0...self.acciones.count-1 {
                        if self.acciones[i].tipo == 3 {
                            self.comentarios.append(self.acciones[i])
                        }
                    }
                    print(self.comentarios.count)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func enviarMensaje( titulo:String, mensaje:String){
        
        let btnAlert = UIAlertController(title: titulo, message:mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
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
