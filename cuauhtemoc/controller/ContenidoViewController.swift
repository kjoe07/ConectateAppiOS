//
//  ContenidoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ContenidoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var busquedaTxt:[String] = []
    var contenido:ContenidoCompleto!
    var dato:[Contenido]! = []
    var busqueda:[Contenido]! = []
    var keywords:[Keyword]! = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buscador: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.buscador.delegate = self
        self.cargarDatos()
    }
    
    @IBAction func btnBuscarContenido(_ sender: Any) {
        
        self.busqueda.removeAll()
        if(self.buscador.text! == ""){
            //self.busqueda.append(contentsOf: self.dato)
        } else {
            
            self.busquedaTxt.append(self.buscador.text!)
            
            for i in 0...self.dato.count-1 {
                for k in 0...self.busquedaTxt.count-1{
                    if(self.dato[i].titulo.lowercased().contains(self.busquedaTxt[k].lowercased())
                    || self.dato[i].body.lowercased().contains(self.busquedaTxt[k].lowercased())){
                    busqueda.append(self.dato[i])
                    } else {
                        if (self.dato[i].keywords.count>0){
                            for j in 0...self.dato[i].keywords.count-1 {
                            if(self.dato[i].keywords[j].tag.contains(self.busquedaTxt[k].lowercased())){
                                busqueda.append(self.dato[i])
                                }
                            }
                        }
                    }
                }
            }
            self.buscador.text = ""
        }
        self.collectionView.reloadData()
        self.tableView.reloadData()
        print(self.busqueda.count)
    }
    
    func cargarDatos(){
        
        let ws = WebServiceClient()
        
        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/contenido/list_post/?page_size=300", method: "GET", completion: { data in
            
                do {
                    self.contenido = try JSONDecoder().decode(ContenidoCompleto.self, from: data as! Data)
                    self.dato.append(contentsOf: self.contenido.results)
                    self.busqueda.append(contentsOf: self.contenido.results)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contenidoViewCell", for: indexPath) as! ContenidoViewCell
        
        cell.txtTitulo.text = self.busqueda[indexPath.row].titulo!
        cell.txtNombreUsuario.text = self.busqueda[indexPath.row].usuario.nombre!
        cell.txtContenido.text = self.busqueda[indexPath.row].body!
        
        if let _ = busqueda[indexPath.row].img {
            let url = "\(Strings().rutaImagen)/\(busqueda[indexPath.row].img!)"
            
            let imageURL = URL(string: url)
            cell.imagenContenido.contentMode = .scaleAspectFit
            cell.imagenContenido.af_setImage(withURL: imageURL!)
        }
        
        if (self.busqueda[indexPath.row].keywords.count>0){
            self.keywords.removeAll()
            cell.keywords.removeAll()
            
            cell.keywords.append(Keyword(id: 0, tipo: 0, tag: self.busqueda[indexPath.row].tipo!, imagen: ""))
            self.keywords.append(contentsOf: self.busqueda[indexPath.row].keywords)
            cell.keywords.append(contentsOf: self.keywords)            
        }
        
        cell.btnLike.tag = indexPath.row
        cell.btnCompartir.tag = indexPath.row
        cell.btnBloquear.tag = indexPath.row
        cell.btnComentarios.tag = indexPath.row
        cell.btnTruques.tag = indexPath.row
        
        cell.btnLike.addTarget(self, action:#selector(btnLike(sender:)) , for: .touchUpInside)
        
        cell.btnCompartir.addTarget(self, action:#selector(btnCompartir(sender:)) , for: .touchUpInside)
        
        cell.btnBloquear.addTarget(self, action:#selector(btnBloquear(sender:)) , for: .touchUpInside)
        
        cell.btnComentarios.addTarget(self, action:#selector(btnComentarios(sender:)) , for: .touchUpInside)
        
        cell.btnTruques.addTarget(self, action:#selector(btnTruques(sender:)) , for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func btnLike(sender:UIButton){
        
        sender.setBackgroundImage(UIImage(named: "img_like_rosa"), for: UIControl.State.normal)
        wsAccion(tipo: "1",post: self.busqueda![sender.tag].id,cuerpo: "")
    }
    
    @objc func btnCompartir(sender:UIButton){
        
    }
    
    @objc func btnBloquear(sender:UIButton){
        
        let btnAlert = UIAlertController(title: "Atención", message:"¿Relamente quieres dejar de ver este contenido?", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Sí", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
            self.wsAccion(tipo: "2",post: self.busqueda![sender.tag].id,cuerpo: "")
        }
        
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    @objc func btnComentarios(sender:UIButton){
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "comentariosViewController") as! ComentariosViewController
        viewController.post = self.busqueda[sender.tag]
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func btnTruques(sender:UIButton){
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ofrecerTruequeViewController") as! OfrecerTruequeViewController
        viewController.post = self.busqueda[sender.tag]
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        
        let ws = WebServiceClient()
        let params = "tipo=\(tipo)&post=\(post)&cuerpo=\(cuerpo)"
        
        DispatchQueue.main.async {
            ws.wsToken(params: params, ws: "/contenido/acciones/add", method: "POST", completion: { data in
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busqueda.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "verContenidoViewController") as! VerContenidoViewController
        controller.contenido = self.dato[indexPath.row]
        self.present(controller, animated: true, completion: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return busquedaTxt.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleHashCollectionViewCell", for: indexPath) as! SimpleHashCollectionViewCell
        cell.txtHashTags.text = "#\(self.busquedaTxt[indexPath.row])"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.busquedaTxt.remove(at: indexPath.row)
        
        if(self.busquedaTxt.count <= 0){
            self.busqueda.append(contentsOf: self.contenido.results)
            self.tableView.reloadData()
        }
        
        collectionView.reloadData()
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
