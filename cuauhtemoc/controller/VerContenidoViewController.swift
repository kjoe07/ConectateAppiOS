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
    var post: Post!
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
        txtUsuario.text = contenido?.usuario?.nombre
        txtNumTrueques.text = "\(contenido?.trueques ?? 0)"//String()
        txtNumPropuestas.text = "\(contenido?.contrataciones ?? 0)"//String()
        txtTelefono.text = String(contenido?.telefono ?? "")
        txtBody.text = contenido?.body
        self.tableView.maxHeight = 200
        
        print(contenido?.tipo ?? "")
        if(contenido?.tipo == "Empleo"){
            btnActionOtro.setTitle("Quiero aplicar", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
        } else if(contenido?.tipo == "Servicio"){
            btnActionOtro.setTitle("Quiero contratar", for: UIControl.State.normal)
        } else if(contenido?.tipo == "Establecimiento"){
            btnActionOtro.setTitle("Quiero contratar", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
        } else if(contenido?.tipo == "Evento"){
            btnActionOtro.setTitle("Quiero asistir", for: UIControl.State.normal)
            btnActionTrueque.isHidden = true
        } else if(contenido?.tipo == "Producto"){
            btnActionOtro.setTitle("Quiero comprar", for: UIControl.State.normal)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.keywords = contenido?.keywords ?? ([Keyword]())
        if self.contenido?.establecimiento == nil{
            self.stackPhone.isHidden = true
            self.stackLocation.isHidden = true
            self.stackSchedule.isHidden = true
            self.map.isHidden = true
        }
        if contenido?.trueques ?? 0 > 0{
            _ = BadgeController(for: btnActionTrueque, in: .upperRightCorner, badgeBackgroundColor: UIColor(named: "green") ?? .green, badgeTextColor: .white, badgeTextFont: nil, borderWidth: 1, borderColor: UIColor(named: "green") ?? .green, animation: nil, badgeHeight: nil, animateOnlyWhenBadgeIsNotYetPresent: true)
        }
        cargarDatos()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
        
        cell.lblTexto.text = self.recursos[indexPath.row].valor
        
        if (self.recursos[indexPath.row].tipo == 3){
            if let url = self.recursos[indexPath.row].valor.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let imageURL = URL(string: url){
                cell.imgPost.contentMode = .scaleToFill
                cell.imgPost.kf.setImage(with: imageURL)//.af_setImage(withURL: imageURL)
            }
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
    
    func cargarDatos(){
        NetworkLoader.loadData(url: "\(Api.singleContent.url)\(contenido?.id ?? 0)/", data: [:], method: .get, completion: {[weak self] (result: MyResult<PostCompleto?>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    if data != nil{
                        self.recursos = data?.recursos
                        self.acciones = data?.acciones
                        self.tableView.reloadData()
                        if data?.post?.establecimiento == nil{
                            self.stackPhone.isHidden = true
                            self.stackLocation.isHidden = true
                            self.stackSchedule.isHidden = true
                            self.map.isHidden = true
                        }else{
                            self.stackPhone.isHidden = false
                            self.stackLocation.isHidden = false
                            self.stackSchedule.isHidden = false
                            self.map.isHidden = false
                            let lat = data?.post?.establecimiento?.latitud ?? "0"
                            let latDouble = Double(lat)
                            let lon = data?.post?.establecimiento?.longitud ?? "0"
                            let long = Double(lon)
                            let location = CLLocationCoordinate2D(latitude: latDouble ?? 0.0, longitude: long ?? 0.0)//data?.post?.establecimiento.
                            let marker = GMSMarker(position: location)
                            marker.icon = #imageLiteral(resourceName: "markerIcon")
                            self.map.animate(toLocation: location)
                        }
                        self.collectionView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
            
        })
//        let ws = WebServiceClient()
//        ws.wsTokenArray(params: "", ws: "/contenido/ver_post/\(self.contenido?.id ?? 0)/", method: "GET", completion: { data in
//
//            do {
//                self.postCompleto = try JSONDecoder().decode(PostCompleto.self, from: data as! Data)
//
//                self.recursos.append(contentsOf: self.postCompleto.recursos)
//                self.acciones.append(contentsOf: self.postCompleto.acciones)
//
//                DispatchQueue.main.async {
//
//                    self.tableView.reloadData()
//                    self.tableView.scrollToRow(at: IndexPath(row:self.postCompleto.recursos.count-1, section:0), at: .top, animated: false)
//                }
//            } catch let jsonError {
//                print(jsonError)
//            }
//        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    @IBAction func btnEmpelo(_ sender: Any) {
        
        
    }
    @objc func btnLike(sender:UIButton){
       // let id = isSearching ? self.busqueda![sender.tag].id ?? 0 : segmented.selectedSegmentIndex == 0 ? result?[sender.tag].id ?? 0 : employ?[sender.tag].id ?? 0
        wsAccion(tipo: "1",post: contenido?.id ?? 0 ,cuerpo: "")
    }
    
    @objc func btnCompartir(sender:UIButton){
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: index) as! ContenidoViewCell
        guard let image2 = cell.imagenContenido else{return}//imageSlider.currentSlideshowItem?.imageView.image else {return}
        let textToShare = [cell.txtTitulo.text ?? "",image2 ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.saveToCameraRoll,.addToReadingList,.copyToPasteboard,.openInIBooks,.mail,.message,.print ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func btnBloquear(sender:UIButton){
        let id = contenido?.id ?? 0
        let btnAlert = UIAlertController(title: "Atención", message:"¿Relamente quieres dejar de ver este contenido?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Sí", style: UIAlertAction.Style.default) {_ in
            self.wsAccion(tipo: "2",post: id,cuerpo: "")
        }
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    @objc func btnComentarios(sender:UIButton){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "comentariosViewController") as! ComentariosViewController
        viewController.post = contenido
        self.present(viewController, animated: true, completion: nil)
    }
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        let params = ["tipo":tipo,"post":post,"cuerpo":cuerpo] as [String : Any]
        NetworkLoader.loadData(url: Api.contentAction.url, data: params, method: .get, completion: {[weak self] (result: MyResult<ActionResponse?>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result{
                case.success(dat: let dat):
                    if dat?.count ?? 0 > 0 {
                        print("success")
                    }
                case .failure(let e):
                    print(e.localizedDescription)
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
}
