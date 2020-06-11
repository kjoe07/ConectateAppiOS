//
//  CargarOfertaViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/24/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
//import CheckBox
import GooglePlacesSearchController
import CoreLocation
import Photos
import GoogleMaps
class CargarOfertaViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate,GooglePlacesAutocompleteViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var lblTipoServicio: UITextField!
    @IBOutlet weak var txtNombreServicio: UITextField!
    @IBOutlet weak var txtEstablishmentLocation: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
   // @IBOutlet weak var ckbTelefono: CheckBox!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtEstablecimiento: UITextField!
    @IBOutlet weak var trippleButton: UIButton!
    @IBOutlet weak var mobileSwitch: UISwitch!
    @IBOutlet weak var establismentSwitch: UISwitch!
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var pickerViewServicio = UIPickerView()
    @IBOutlet weak var saveButton: BorderCurvedButton!
    var pickerViewHashTags = UIPickerView()
    var recursos:[Recurso]!  = []
    var tipoServicio:[String] = ["Empleo","Servicio","Establecimiento", "Evento", "Producto"]
    var dato:[Keyword]? = []
    var busqueda:[Keyword]? = []
    var intereses:[Int] = []
    var guardado:[Keyword]? = []
    var GPSc: GooglePlacesSearchController?
    let imagePicker = UIImagePickerController()
    var imageArray = [UIImage]()
    let locationDelegate = LocationCoordinateDelegate()
    var establistmnetLocation = false
    var phone: String?
    var post: Post?
    //MARK: - View Functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTipoServicio.delegate = self
        txtNombreServicio.delegate = self
        //txtHasTags.delegate = self
        txtDescripcion.delegate = self
        txtTelefono.delegate = self
        //txtEstablecimiento.delegate = self
        pickerViewServicio.delegate = self
        pickerViewHashTags.delegate = self
        cargarServicio()
        cargarDatos()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        tableView.isHidden = true
        GPSc = GooglePlacesSearchController(delegate: self, apiKey: "AIzaSyADPJdpByqnYJUcFu2FlXKjWGVOARShVMw", placeType: .address, coordinate: CLLocationCoordinate2D(latitude: 23.6345005, longitude: -102.5527878) , radius: .zero, strictBounds: false, searchBarPlaceholder: "Entre la dirección")
        locationDelegate.requestAuthorization()
        locationDelegate.updated = { [weak self] loc in
            print("Location updated closure")
            let marker = GMSMarker(position: loc)
            marker.map = self?.map
            self?.map.animate(toLocation: loc)
            self?.map.animate(toZoom: 14)
        }
        let userData = UserDefaults.standard.value(forKey: "usuario") as? Data
        guard let user = try? JSONDecoder().decode(Usuario.self, from: userData ?? Data()) else {return}
        txtTelefono.text = user.celular ?? ""
        phone =  user.celular ?? ""
        if post != nil{
            lblTipoServicio.text = post?.tipo ?? ""
            txtNombreServicio.text = post?.titulo ?? ""
            txtDescripcion.text = post?.body ?? ""
            self.guardado = post?.keywords
            self.collectionView.reloadData()
            saveButton.setTitle("Editar servicio", for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        cargarServicio()
        cargarDatos()
        if post == nil {
            self.navigationController?.navigationBar.isHidden = true
        }        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    //MARK: - Actions -
    
    @IBAction func btnAgregar(_ sender: Any) {
        if txtNombreServicio.text != "" && lblTipoServicio.text != "" && guardado?.count ?? 0 > 0{
            sendRequest()
        }else{
            self.showAlert(title: "Ups!", message: "es necesario completar todos los campos para continuar")
        }
    }
    
    @IBAction func btnCalendario(_ sender: Any) {
        FechaAlertView.instance.showAlert()
        FechaAlertView.instance.selected = { fecha,hora in
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: "\(fecha):\(hora)", tipo: 2))
            self.tableView.reloadData()
        }
        tableView.isHidden = false
    }
    @IBAction func btnUrl(_ sender: Any) {
        tableView.isHidden = false
        let ac = UIAlertController(title: "Escribe el enlace que quieres publicar", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields?[0].text ?? ""
            if answer != ""{
                self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 6))
                self.tableView.reloadData()
            }else{
                self.showAlert(title: "Ups!", message: "No es un enlace válido")
            }
        }
        ac.addAction(submitAction)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    @IBAction func btnMetodoPago(_ sender: Any) {
        tableView.isHidden = false
        let vc = self.storyboard?.instantiateViewController(identifier: "method") as! MethodViewController
        vc.selected = { vals in
            for val in vals{
                self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: val, tipo: 11))
            }
            self.tableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnTexto(_ sender: Any) {
        tableView.isHidden = false
       let ac = UIAlertController(title: "Agregar contenido (texto)", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            print(answer)
            if answer != ""{
                self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 13))
                self.tableView.reloadData()
            }
        }
        ac.addAction(submitAction)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    @IBAction func btnRedes(_ sender: Any) {
        tableView.isHidden = false
        let ac = UIAlertController(title: "Agregar redes sociales", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: { text in
            text.placeholder = "Facebook"
        })
        ac.addTextField(configurationHandler: { text in
            text.placeholder = "Twitter"
        })
        ac.addTextField(configurationHandler: { text in
            text.placeholder = "Linkedin"
        })
        ac.addTextField(configurationHandler: { text in
            text.placeholder = "Instagram"
        })
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            for i in 0..<(ac.textFields?.count ?? 0){
                let answer = ac.textFields?[i].text ?? ""
                if answer != "" {
                    self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 12))
                }
            }
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        ac.addAction(cancel)
        present(ac, animated: true)
    }

    
    @IBAction func btnPrecio(_ sender: Any) {
        tableView.isHidden = false
        let ac = UIAlertController(title: "Ingresa un Precio", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].keyboardType = .numberPad
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 10))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    @IBAction func btnUbicacion(_ sender: Any) {
        tableView.isHidden = false
        present(GPSc ?? GooglePlacesSearchController(searchResultsController: nil), animated: true, completion: nil)
    }
    @IBAction func btnImagen(_ sender: Any) {
        tableView.isHidden = false    
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status{
            case .authorized:
                DispatchQueue.main.async {
                     self.loadFromLibrary()
                }
            case .denied:
                self.pedirPermiso(titulo: "Debes habilitar permisos", mensaje: "Para modificar tu foto de perfil es necesario habilites los permisos", aceptar: "Otorgar permiso")
                break
            case .notDetermined, .restricted:
                break
            @unknown default:
                break
            }
        }
    }
    
    func pedirPermiso(titulo:String, mensaje:String, aceptar:String){
        let alertController = UIAlertController (title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        let settingsAction = UIAlertAction(title: aceptar, style: UIAlertAction.Style.default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func loadFromLibrary(){
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            let name = info[.imageURL] as? URL
            let imageName = name?.lastPathComponent
            let ext = name?.pathExtension
            let imageNameExt = "\(imageName ?? "").\(ext ?? "")"
            self.recursos.append(Recurso(id: 0, orden: imageArray.count, post: 0, valor: imageNameExt, tipo: 3))
            imageArray.append(image)
            tableView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Table Fucntions -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Post2TableViewCell
        cell.lblTexto.text = self.recursos[indexPath.row].valor
        if(self.recursos[indexPath.row].tipo == 3){
            print("imagen 3")
            //cell.imgServicio.image = UIImage(named: "servicio_imagen")
            let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell") as! PostTableViewCell
            print("should load and image")
            let id = self.recursos[indexPath.row].orden
            cell.imgPost.image = imageArray[id ?? 0]
            return cell
        }  else if(self.recursos[indexPath.row].tipo == 4){
            cell.imgServicio.image = UIImage(named: "servicio_video")
        } else if(self.recursos[indexPath.row].tipo == 5){
            cell.imgServicio.image = UIImage(named: "servicio_documento")
        } else if(self.recursos[indexPath.row].tipo == 6){
            cell.imgServicio.image = UIImage(named: "servicio_enlace")
        }else if(self.recursos[indexPath.row].tipo == 9){
            cell.imgServicio.image = UIImage(named: "location")
        } else if(self.recursos[indexPath.row].tipo == 10){
            cell.imgServicio.image = UIImage(named: "servicio_precio")
        } else if(self.recursos[indexPath.row].tipo == 11){
            cell.imgServicio.image = UIImage(named: "servicio_metodos_de_pago")
        } else if(self.recursos[indexPath.row].tipo == 12){
            cell.imgServicio.image = UIImage(named: "servicio_redes")
        } else if(self.recursos[indexPath.row].tipo == 13){
            cell.imgServicio.image = UIImage(named: "servicio_texto")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recursos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.recursos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    //MARK: -   -
//    func cargarHashTags(){
//        txtHasTags.inputView = pickerViewHashTags
//        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
//        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
//        toolBar.barStyle = UIBarStyle.black
//        toolBar.tintColor = UIColor.white
//        toolBar.backgroundColor = UIColor(red: 0.49411764705882, green: 0, blue: 0.49411764705882, alpha: 0)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed2) )
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
//        label.font = UIFont(name: "Helvetica", size: 13)
//        label.backgroundColor = UIColor.clear
//        label.textColor = UIColor.white
//        label.text = "Selecciona:"
//        label.textAlignment = NSTextAlignment.center
//        let textBtn = UIBarButtonItem(customView: label)
//        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
//        txtHasTags.inputAccessoryView = toolBar
//    }
//
//    @objc func donePressed2() {
//         print("Ingreso")
//        if let index = intereses.firstIndex(of: self.busqueda?[pickerViewHashTags.selectedRow(inComponent: 0)].id ?? 0){
//            print("No hay")
//            intereses.remove(at: index)
//            guardado?.remove(at: index)
//        } else {
//            print("Agregando")
//            if(self.intereses.count >= 5){
//                self.showAlert(title: "Ups", message: "Solo puedes agregar 5 hashtags")
//            } else {
//                intereses.append(self.busqueda?[pickerViewHashTags.selectedRow(inComponent: 0)].id ?? 0)
//            }
//        }
//        txtHasTags.resignFirstResponder()
//        collectionView.reloadData()
//    }
    
    func cargarServicio(){
        lblTipoServicio.inputView = pickerViewServicio
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.black
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor(red: 0.49411764705882, green: 0, blue: 0.49411764705882, alpha: 0)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed) )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Selecciona:"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        lblTipoServicio.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        lblTipoServicio.resignFirstResponder()
        lblTipoServicio.text = tipoServicio[pickerViewServicio.selectedRow(inComponent: 0)]
    }
    //MARK: - Picker -
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewServicio{
            return tipoServicio.count
        } else if pickerView == pickerViewHashTags {
            return busqueda?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewServicio {
            return tipoServicio[row]
        } else if pickerView == pickerViewHashTags {
            return busqueda?[row].tag
        }
        return nil
    }
    //MARK: - CollectionView Functions -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guardado?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/3.0), height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleHashCollectionViewCell", for: indexPath) as! SimpleHashCollectionViewCell
        cell.txtHashTags.text = "#\(guardado?[indexPath.row].tag ?? "")"
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
        intereses.remove(at: indexPath.row)
        guardado?.remove(at: indexPath.row)
        self.collectionView.reloadData()
    }
    //MARK: - Request Functions -
    func cargarDatos(){
        print("load data:")
        let params = ["page_size":2000]
        NetworkLoader.loadData(url: Api.listHashTagsByKeyword.url, data: params, method: .get, completion: {[weak self] (result:MyResult<HashtagProfileResponse>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result{
                case .success(dat: let data):
                    if data.count ?? 0 > 0{
                        self.dato = data.results
                        self.collectionView.reloadData()
                    }
                case .failure(let e):
                    self.showAlert(title: "¡Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    fileprivate func sendRequest() {
        var params = ["titulo":txtNombreServicio.text ?? "","tipo":"\(pickerViewServicio.selectedRow(inComponent: 0)+1)","body":self.txtDescripcion.text ?? "","flag_telefono":true] as [String : Any]
        if establismentSwitch.isOn{
            params["establecimiento"] = 1
        }
        if mobileSwitch.isOn{
            params["telefono"] = txtTelefono.text ?? ""
        }
        showActivityIndicator(color: UIColor(named: "green") ?? .green)
        NetworkLoader.loadData(url: Api.createContent.url, data: params, method: .post, completion: { [weak self] (result: MyResult<ResponseAddPost>) in
            DispatchQueue.main.async {
                print("the resul:",result)
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ofertCreated"), object: nil)
                    for i in 0..<(self.guardado?.count ?? 0) {
                        self.agregarKeyword(post: data.id ?? 0,keyword: self.guardado?[i].id ?? 0)
                    }
                    for i in 0..<self.recursos.count {
                        if(self.recursos[i].tipo == 3){
                            for j in 0..<self.imageArray.count{
                                //guard let image  =  else {return}
                                self.uploadImages(post: data.id ?? 0, valor: self.recursos[i].valor, Tipo: 3, image: self.imageArray[j] )
                            }
                        } else if(self.recursos[i].tipo == 6){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_url", tipo: nil)
                        } else if(self.recursos[i].tipo == 8){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_fecha", tipo: nil)
                        } else if(self.recursos[i].tipo == 9){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_ubicacion", tipo: nil)
                        } else if(self.recursos[i].tipo == 10){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_precio", tipo: nil)
                        } else if(self.recursos[i].tipo == 11){
                            //self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_texto", tipo: self.recursos[i].tipo.description)
                            // self.subirText(post: data.id ?? 0, valor: self.recursos[i].valor, tipo: self.recursos[i].tipo)
                        } else if(self.recursos[i].tipo == 12){
                            //self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_texto", tipo: self.recursos[i].tipo.description)
                        } else if(self.recursos[i].tipo == 13){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_texto", tipo: self.recursos[i].tipo.description)
                        }
                    }
                    self.hideActivityIndicator()
                    let alert = UIAlertController(title: "Felicidades", message: "¡Tu oferta fue cargado con éxito!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                        let vc = self.storyboard?.instantiateViewController(identifier: "CargarOfertaViewController") ?? CargarOfertaViewController()
                                           var vcs = self.navigationController?.viewControllers
                        vcs?.removeLast()
                        vcs?.append(vc)
                        self.navigationController?.setViewControllers(vcs ?? [vc], animated: false)
                        (self.parent?.parent as? UITabBarController)?.selectedIndex = 0
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    //self.showAlert(title: "Felicidades", message: "¡Tu oferta fue cargado con éxito!")
                   
                case .failure(let e):
                    self.hideActivityIndicator()
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    func agregarKeyword(post:Int, keyword:Int){
        let params = ["post": post,"keyword":keyword]
        NetworkLoader.loadData(url: Api.addKeywordPost.url, data: params, method: .post, completion: {[weak self] (result:MyResult<AddPostResponse?>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let dat):
                    if dat == nil{
                        self.showAlert(title: "Ups!", message: "ocurrio un error")
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
        
    func subirURL(post:Int, valor:String, url:String,tipo:String?){
        var params = ["post":"\(post)","valor":valor]
        if url == "add_texto"{
            params["tipo"] = tipo
        }
        NetworkLoader.loadData(url: "\(server.ws)/contenido/\(url)/", data: params, method: .post, completion: { [weak self] (result: MyResult<AddURlResponse?>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    if data == nil{
                        self.showAlert(title: "Ups!", message: "error al subir \(url)")
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    func uploadImages(post id: Int,valor:String,Tipo: Int,image: UIImage){
        let params = ["post":id.description,"tipo":Tipo.description] //as [String : Any]
        let imageData = image.pngData()
        //TODO: - Find tje codable value in this request.
        NetworkLoader.sendPostFormData(formFields: params, url: Api.addFile.url, imageData: imageData, completion: {[weak self] (result:MyResult<Usuario>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    //FIXME: - verify the response and do proper responses
                    print("success")
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
            
        })
    }
     //MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HashtagTableViewController
        vc.result = self.dato
        vc.editingModel = self.guardado //?? [Results]()
        vc.selectedHashtag = { val in
            self.view.endEditing(true)
            self.guardado = val
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func showSearch(_ sender: Any) {
        self.view.endEditing(true)
        self.txtNombreServicio.resignFirstResponder()
        self.txtNombreServicio.endEditing(true)
        self.performSegue(withIdentifier: "single", sender: self)
    }
    @IBAction func phoneActivated(_ sender: Any) {
        if (sender as! UISwitch).isOn {
            txtTelefono.isUserInteractionEnabled = true
            txtTelefono.text = ""
        }else{
            txtTelefono.isUserInteractionEnabled = false
            txtTelefono.text = phone ?? ""
        }
    }
    @IBAction func locationActivated(_ sender: Any) {
        if (sender as! UISwitch).isOn{
            txtEstablecimiento.isHidden = false
            txtEstablishmentLocation.isHidden = false
            map.isHidden = false
        }else{
            txtEstablecimiento.isHidden = true
            txtEstablishmentLocation.isHidden = true
            map.isHidden = true
        }        
    }
    
    @IBAction func setAddress(_ sender: Any) {
        establistmnetLocation = true
        present(GPSc ?? GooglePlacesSearchController(searchResultsController: nil), animated: true, completion: nil)
    }
    
    func viewController(didAutocompleteWith place: PlaceDetails) {
        if establistmnetLocation{
            print(place.description)
            GPSc?.isActive = false
            txtEstablecimiento.text = place.formattedAddress
            let location = place.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            let marker = GMSMarker()
            marker.icon = #imageLiteral(resourceName: "markerIcon")
            marker.position = location
            marker.map = map
            map.animate(toLocation: location)
        }else{
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: place.formattedAddress, tipo: 9))
            self.tableView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
       // placesSearchController.isActive = false
    }
    @IBAction func deleteAll(_ sender: UIButton){
           self.recursos.removeAll()
           self.tableView.reloadData()
    }
}
