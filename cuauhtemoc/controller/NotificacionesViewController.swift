//
//  NotificacionesViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class NotificacionesViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var notificacion:NotificacionCompleto!
    var notificaciones:[Notificacion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        cargarDatos()
        // Do any additional setup after loading the view.
    }
    
    func cargarDatos(){
        
        let ws = WebServiceClient()
        print("WS")

        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/usuarios/notificaciones/?page_size=30", method: "GET", completion: { data in
                
                do {
                    self.notificacion = try JSONDecoder().decode(NotificacionCompleto.self, from: data as! Data)
                    
                    self.notificaciones.append(contentsOf: self.notificacion.results)
                
                    if(self.notificacion.results.count > 0){
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificacionesTableViewCell", for: indexPath) as! NotificacionesTableViewCell
        
        cell.txtNotificacion.text = self.notificacion.results[indexPath.row].cuerpo
        
        if self.notificacion.results[indexPath.row].content_object.tipo == 1 {
            cell.imgTipoNotificacion.image = UIImage(named: "img_like_rosa")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 2 {
            cell.imgTipoNotificacion.image = UIImage(named: "btn_bloqueat")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 3 {
            cell.imgTipoNotificacion.image = UIImage(named: "img_mensaje")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 4 {
            cell.imgTipoNotificacion.image = UIImage(named: "img_trueque_morado")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 5 {
            cell.imgTipoNotificacion.image = UIImage(named: "img_contratar_morado")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 6 {
            cell.imgTipoNotificacion.image = UIImage(named: "btn_add_circulo_amarillo")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 7 {
            cell.imgTipoNotificacion.image = UIImage(named: "img_lapiz_morado")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 8 {
            cell.imgTipoNotificacion.image = UIImage(named: "servicio_precio")
            
        } else if self.notificacion.results[indexPath.row].content_object.tipo == 9 {
            cell.imgTipoNotificacion.image = UIImage(named: "servicio_redes")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificaciones.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func btnMercado(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "contenidoViewController") as! ContenidoViewController
    
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func btnCargarOferta(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "cargarOfertaViewController") as! CargarOfertaViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnNotificaciones(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "notificacionesViewController") as! NotificacionesViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnPerfil(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "perfilCompletoViewController") as! PerfilCompletoViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnEmpelo(_ sender: Any) {
        
        
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
