//
//  VerContenidoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/22/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class VerContenidoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
   
    var contenido:Contenido!
    var keywords:[Keyword]! = []
    var post:Post!
    var postCompleto:PostCompleto!
    var recursos:[Recurso]!  = []
    var acciones:[Accion]!  = []
    let imagenes = ["servicio_documento", "servicio_enlace", "servicio_calendario","servicio_calendario", "servicio_ubicacion", "servicio_precio","servicio_metodos_de_pago", "servicio_redes", "servicio_texto"]
    
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtUsuario: UILabel!
    @IBOutlet weak var txtCoincidencia: UILabel!
    @IBOutlet weak var txtNumTrueques: UILabel!
    @IBOutlet weak var txtNumPropuestas: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtTelefono: UILabel!
    @IBOutlet weak var txtBody: UILabel!
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var btnActionTrueque: UIButton!
    @IBOutlet weak var btnActionOtro: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtTitulo.text = contenido.titulo
        txtUsuario.text = contenido.usuario?.nombre
        txtNumTrueques.text = "\(contenido.trueques ?? 0)"//String()
        txtNumPropuestas.text = "\(contenido.contrataciones ?? 0)"//String()
        txtTelefono.text = String(contenido.telefono ?? "")
        txtBody.text = contenido.body
        self.tableView.maxHeight = 200
        
        print(contenido.tipo ?? "")
        if(contenido.tipo == "Empleo"){
            btnActionOtro.setTitle("Quiero aplicar", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
        } else if(contenido.tipo == "Servicio"){
            btnActionOtro.setTitle("Quiero contratar", for: UIControl.State.normal)
        } else if(contenido.tipo == "Establecimiento"){
            btnActionOtro.setTitle("Quiero contratar", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
        } else if(contenido.tipo == "Evento"){
            btnActionOtro.setTitle("Quiero asistir", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
        } else if(contenido.tipo == "Producto"){
            btnActionOtro.setTitle("Quiero comprar", for: UIControl.State.normal)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        keywords.append(Keyword(id: 0, tipo: 0, tag: contenido.tipo ?? "", imagen: ""))
        keywords.append(contentsOf: self.contenido.keywords!)

        cargarDatos()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
        
        cell.lblTexto.text = self.recursos[indexPath.row].valor
        
        if (self.recursos[indexPath.row].tipo == 3){
            
           
            let url = self.recursos[indexPath.row].valor
            let imageURL = URL(string: url!)
            cell.imgPost.contentMode = .scaleAspectFit
            cell.imgPost.af_setImage(withURL: imageURL!)
            cell.imgPost.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            
            cell.lblTexto.isHidden = true
            cell.imgServicio.isHidden = true
            self.tableView.rowHeight = 220
    
        } else {
            cell.lblTexto.isHidden = false
            cell.imgServicio.isHidden = false
            cell.imgPost.isHidden = true
            
            self.tableView.rowHeight = 40
        }
        
        if(self.recursos[indexPath.row].tipo >= 5){
            cell.imgServicio.image = UIImage(named: self.imagenes[self.recursos[indexPath.row].tipo-5])

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recursos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func enviarMensaje( titulo:String, mensaje:String){
        
        let btnAlert = UIAlertController(title: titulo, message:mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleHashCollectionViewCell", for: indexPath) as! SimpleHashCollectionViewCell
        
        cell.txtHashTags.text = "#\(keywords[indexPath.row].tag!)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    @IBAction func regresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cargarDatos(){        
        let ws = WebServiceClient()
        ws.wsTokenArray(params: "", ws: "/contenido/ver_post/\(self.contenido.id!)/", method: "GET", completion: { data in
            
            do {
                self.postCompleto = try JSONDecoder().decode(PostCompleto.self, from: data as! Data)
                
                self.recursos.append(contentsOf: self.postCompleto.recursos)
                self.acciones.append(contentsOf: self.postCompleto.acciones)
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row:self.postCompleto.recursos.count-1, section:0), at: .top, animated: false)
                }
            } catch let jsonError {
                print(jsonError)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
}
