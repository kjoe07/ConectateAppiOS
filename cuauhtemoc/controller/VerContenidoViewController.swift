//
//  VerContenidoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/22/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
import GoogleMaps
import BadgeControl
class VerContenidoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
   
    var contenido: Post?
    var keywords:[Keyword]! = []
    var post: Post?
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
    @IBOutlet weak var stackPhone: UIStackView!
    @IBOutlet weak var stackSchedule: UIStackView!
    @IBOutlet weak var stackLocation: UIStackView!
    @IBOutlet weak var map: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let like : UIButton = UIButton.init(type: .custom)
        like.setImage(#imageLiteral(resourceName: "likeNavigationBar"), for: .normal)
        like.addTarget(self, action: #selector(btnLike(sender:)), for: .touchUpInside)
        like.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        like.tintColor = UIColor(named: "green")
        let likeButton = UIBarButtonItem(customView: like)
        //let likeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "likeNavigationBar"), style: .plain, target: self, action: #selector(self.btnLike(sender:)))
        likeButton.tintColor = UIColor(named: "green")
        let block = UIButton(type: .custom)
        block.setImage(#imageLiteral(resourceName: "bloknavigationBar"), for: .normal)
        block.addTarget(self, action: #selector(self.btnBloquear(sender:)), for: .touchUpInside)
        block.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let blockButton = UIBarButtonItem(customView: block)//UIBarButtonItem(image: #imageLiteral(resourceName: "bloknavigationBar"), style: .plain, target: self, action: #selector(self.btnBloquear(sender:)))
        //blockButton.imageInsets = UIEdgeInsets(top: 3, left: 10, bottom: 7, right: 0)
        let share = UIButton(type: .custom)
        share.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        share.addTarget(self, action: #selector(self.btnCompartir(sender:)), for: .touchUpInside)
        share.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        share.tintColor = UIColor(named: "green")
        let shareButton =  UIBarButtonItem(customView: share)//UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(self.btnCompartir(sender:)))
        //shareButton.imageInsets = UIEdgeInsets(top: 3, left: 10, bottom: 7, right: 0)
        let message = UIButton(type: .custom)
        message.setImage(#imageLiteral(resourceName: "messageNavigationbar"), for: .normal)
        message.addTarget(self, action: #selector(self.btnComentarios(sender:)), for: .touchUpInside)
        message.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        message.tintColor = UIColor(named: "green")
        let messageButton = UIBarButtonItem(customView: message)// UIBarButtonItem(image: #imageLiteral(resourceName: "messageNavigationbar"), style: .plain, target: self, action: #selector(self.btnComentarios(sender:)))
        messageButton.imageInsets = UIEdgeInsets(top: 3, left: 10, bottom: 7, right: 0)
        self.navigationItem.setRightBarButtonItems([messageButton,shareButton,blockButton, likeButton],animated: true) //rightBarButtonItems = [likeButton,blockButton,shareButton,messageButton]
        txtTitulo.text = contenido?.titulo
        //txtUsuario.text = contenido?.usuario?.nombre
        txtNumTrueques.text = "\(contenido?.trueques ?? 0)"//String()
        txtNumPropuestas.text = "\(contenido?.contrataciones ?? 0)"//String()
        txtTelefono.text = String(contenido?.telefono ?? "")
        txtBody.text = contenido?.body
        self.tableView.maxHeight = 200
        
        print(contenido?.tipo ?? "")
        if(contenido?.tipo == "Empleo"){
            btnActionOtro.setTitle("Quiero aplicar", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
            
            btnActionOtro.addTarget(self, action: #selector(self.btnAsistir(sender:)), for: .touchUpInside)
            
        } else if(contenido?.tipo == "Servicio"){
            
            btnActionOtro.setTitle("Quiero contratar", for: UIControl.State.normal)
            
            btnActionOtro.addTarget(self, action: #selector(self.btnContratar(sender:)), for: .touchUpInside)
            btnActionTrueque.addTarget(self, action: #selector(self.btnTrueque(sender:)), for: .touchUpInside)
            
        } else if(contenido?.tipo == "Establecimiento"){
            btnActionOtro.setTitle("Quiero contratar", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
            
            btnActionTrueque.addTarget(self, action: #selector(self.btnTrueque(sender:)), for: .touchUpInside)
            btnActionOtro.addTarget(self, action: #selector(self.btnContratar(sender:)), for: .touchUpInside)
            
        } else if(contenido?.tipo == "Evento"){
            btnActionOtro.setTitle("Quiero asistir", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
            
            btnActionOtro.addTarget(self, action: #selector(self.btnAsistir(sender:)), for: .touchUpInside)
            
        } else if(contenido?.tipo == "Producto"){
            
            btnActionOtro.setTitle("Quiero comprar", for: UIControl.State.normal)
            
            btnActionOtro.addTarget(self, action: #selector(self.btnComprar(sender:)), for: .touchUpInside)
            btnActionTrueque.addTarget(self, action: #selector(self.btnTrueque(sender:)), for: .touchUpInside)

        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.keywords = contenido?.keywords ?? ([Keyword]())
        if self.contenido?.establecimiento == nil{
            self.stackPhone.isHidden = true
            self.stackLocation.isHidden = true
            
            self.map.isHidden = true
        }
        if contenido?.trueques ?? 0 > 0{
            _ = BadgeController(for: btnActionTrueque, in: .upperRightCorner, badgeBackgroundColor: UIColor(named: "green") ?? .green, badgeTextColor: .white, badgeTextFont: nil, borderWidth: 1, borderColor: UIColor(named: "green") ?? .green, animation: nil, badgeHeight: nil, animateOnlyWhenBadgeIsNotYetPresent: true)
        }
        tableView.isHidden = true
        cargarDatos()
        //map.animate(toZoom: 17)
        map.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.recursos[indexPath.row].tipo == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
            if let url = self.recursos[indexPath.row].valor.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let imageURL = URL(string: url){
                cell.imgPost.contentMode = .scaleToFill
                cell.imgPost.kf.setImage(with: imageURL)//.af_setImage(withURL: imageURL)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Post2TableViewCell
            
            cell.lblTexto.text = self.recursos[indexPath.row].valor
            print(self.recursos[indexPath.row].tipo!)
            
            if(self.recursos[indexPath.row].tipo >= 5){
                cell.imgServicio.image = UIImage(named: self.imagenes[self.recursos[indexPath.row].tipo-5])
            } else {
                cell.imgServicio.image = UIImage(named: self.imagenes[self.recursos[indexPath.row].tipo])
            }
            return cell
        }
        //return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recursos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 25)
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
    
    func cargarDatos(){
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: "\(Api.singleContent.url)\(contenido?.id ?? 0)/", data: [:], method: .get, completion: {[weak self] (result: MyResult<PostCompleto?>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let data):
                    if data != nil{
                        self.acciones = data?.acciones
                        if data?.post?.establecimiento == nil{
                            self.stackPhone.isHidden = true
                            self.stackLocation.isHidden = true
                            //self.stackSchedule.isHidden = true
                            self.map.isHidden = true
                        }else{
                            self.stackPhone.isHidden = false
                            self.stackLocation.isHidden = false
                            //self.stackSchedule.isHidden = false
                            self.txtUsuario.text = data?.post?.establecimiento?.nombre ?? ""
                            self.map.isHidden = false
                            let lat = data?.post?.establecimiento?.latitud ?? "0"
                            let latDouble = Double(lat)
                            let lon = data?.post?.establecimiento?.longitud ?? "0"
                            let long = Double(lon)
                            let location = CLLocationCoordinate2D(latitude: latDouble ?? 0.0, longitude: long ?? 0.0)//data?.post?.establecimiento.
                            print("location:",location)
                            let marker = GMSMarker()
                            marker.icon = #imageLiteral(resourceName: "markerIcon")
                            marker.position = location
                            marker.title = self.post?.establecimiento?.nombre
                            marker.map = self.map
                            self.map.animate(toLocation: location)
                            self.map.animate(toZoom: 17)
                        }
                        self.collectionView.reloadData()
                    }
                    if data?.recursos.count ?? 0 > 0{
                        self.recursos = data?.recursos
                        self.tableView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
            
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func btnAsistir(sender:UIButton){
       // let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        wsAccion(tipo: "9", post: contenido?.id ?? 0 ,cuerpo: "", mensajeExito:"Tu solicitud de evento fue enviada, te notificaremos cuando tengamos una respuesta ")
    }
    
    @objc func btnTrueque(sender:UIButton){

        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ofrecerTruequeViewController") as! OfrecerTruequeViewController
        viewController.post =  post
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func btnContratar(sender:UIButton){
       // let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        wsAccion(tipo: "5",post: contenido?.id ?? 0 ,cuerpo: "", mensajeExito: "Tu solicitud de contratación fue enviada, te notificaremos cuando tengamos una respuesta")
    }
    
    @objc func btnAplicar(sender:UIButton){
       // let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        wsAccion(tipo: "7",post: contenido?.id ?? 0 ,cuerpo:"", mensajeExito:"Tu solicitud de empleo fue enviada, te notificaremos cuando tengamos una respuesta")
    }
    
    @objc func btnComprar(sender:UIButton){
       // let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        wsAccion(tipo: "8",post: contenido?.id ?? 0 ,cuerpo: "", mensajeExito: "Tu solicitud de compra fue enviada, te notificaremos cuando tengamos una respuesta")
    }
    
    @objc func btnLike(sender:UIButton){
       // let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        sender.isSelected = true
        post?.likes = 1
        wsAccion(tipo: "1",post: contenido?.id ?? 0 ,cuerpo: "", mensajeExito: "")
    }
    
    @objc func btnCompartir(sender:UIButton){
        //let index = IndexPath(row: sender.tag, section: 0)
        //let cell = tableView.cellForRow(at: index) as! ContenidoViewCell
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        // renders the view's layer into the current graphics context
        if let context = UIGraphicsGetCurrentContext() { view.layer.render(in: context) }

        // creates UIImage from what was drawn into graphics context
        guard let screenshot: UIImage = UIGraphicsGetImageFromCurrentImageContext() else{
            return
        }

        // clean up newly created context and return screenshot
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
       // guard let image2 = self.//cell.imagenContenido else{return}//imageSlider.currentSlideshowItem?.imageView.image else {return}
        let textToShare = [screenshot] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.saveToCameraRoll,.addToReadingList,.copyToPasteboard,.openInIBooks,.mail,.message,.print ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func btnBloquear(sender:UIButton){
        let id = contenido?.id ?? 0
        let btnAlert = UIAlertController(title: "Atención", message:"¿Relamente quieres dejar de ver este contenido?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Sí", style: UIAlertAction.Style.default) {_ in
            self.wsAccion(tipo: "2",post: id,cuerpo: "" , mensajeExito: "")
        }
        btnAlert.addAction(okAction)
        btnAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    @objc func btnComentarios(sender:UIButton){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "comentariosViewController") as! ComentariosViewController
        viewController.post = contenido
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func wsAccion(tipo:String, post:Int, cuerpo:String, mensajeExito:String ){
        let params = ["tipo":tipo,"post":post,"cuerpo":cuerpo] as [String : Any]
        NetworkLoader.loadData(url: Api.contentAction.url, data: params, method: .post, completion: {[weak self] (result: MyResult<ActionResponse?>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result{
                case.success(dat: let dat):
                    if dat?.count ?? 0 > 0 {
                        print("success")
                    }
                    
                    if tipo == "5" || tipo == "7" || tipo == "8" || tipo == "9" {
                        self.showAlert(title: "#Conectate", message: mensajeExito)
                    }
                    
                case .failure(let e):
                    print(e.localizedDescription)
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
}
