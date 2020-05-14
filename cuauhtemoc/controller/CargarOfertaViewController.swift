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
class CargarOfertaViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate,GooglePlacesAutocompleteViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var lblTipoServicio: UITextField!
    @IBOutlet weak var txtNombreServicio: UITextField!
    @IBOutlet weak var txtHasTags: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
   // @IBOutlet weak var ckbTelefono: CheckBox!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtEstablecimiento: UITextField!
    @IBOutlet weak var trippleButton: UIButton!
    @IBOutlet weak var mobileSwitch: UISwitch!
    @IBOutlet weak var establismentSwitch: UISwitch!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var pickerViewServicio = UIPickerView()
    var pickerViewHashTags = UIPickerView()
    var recursos:[Recurso]!  = []
    var tipoServicio:[String] = ["Empleo","Servicio","Establecimiento", "Evento", "Producto"]
    var dato:[Results]? = []
    var busqueda:[Results]? = []
    var intereses:[Int] = []
    var guardado:[Results]? = []
    var GPSc: GooglePlacesSearchController?
    let imagePicker = UIImagePickerController()
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
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnAgregar(_ sender: Any) {
        let params = ["titulo":txtNombreServicio.text ?? "","tipo":"\(pickerViewServicio.selectedRow(inComponent: 0)+1)","body":self.txtDescripcion.text ?? "","flag_telefono":true] as [String : Any]
        NetworkLoader.loadData(url: Api.createContent.url, data: params, method: .post, completion: { [weak self] (result: MyResult<AddPostResponse>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result{
                case .success(dat: let data):
                    for i in 0..<(self.guardado?.count ?? 0) {
                       // self.subirURL(post: data.id ?? 0, valor: (self.guardado?[i].id?.description ?? ""), url: "add_keyword_post", tipo: nil)
                        self.agregarKeyword(post: data.id ?? 0,keyword: self.guardado?[i].id ?? 0)
                    }
                    for i in 0..<self.recursos.count {
                        if(self.recursos[i].tipo == 3){
                        }  else if(self.recursos[i].tipo == 4){
                        } else if(self.recursos[i].tipo == 5){
                        } else if(self.recursos[i].tipo == 6){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_url", tipo: nil)
                        } else if(self.recursos[i].tipo == 8){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_fecha", tipo: nil)
                        } else if(self.recursos[i].tipo == 9){
                        } else if(self.recursos[i].tipo == 10){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_precio", tipo: nil)
                        } else if(self.recursos[i].tipo == 11){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_texto", tipo: self.recursos[i].tipo.description)
                           // self.subirText(post: data.id ?? 0, valor: self.recursos[i].valor, tipo: self.recursos[i].tipo)
                        } else if(self.recursos[i].tipo == 12){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_texto", tipo: self.recursos[i].tipo.description)
                           // self.subirText(post: data.id ?? 0, valor: self.recursos[i].valor, tipo: self.recursos[i].tipo)
                        } else if(self.recursos[i].tipo == 13){
                            self.subirURL(post: data.id ?? 0, valor: self.recursos[i].valor, url: "add_texto", tipo: self.recursos[i].tipo.description)
                            //self.subirText(post: data.id ?? 0, valor: self.recursos[i].valor, tipo: self.recursos[i].tipo)
                        }
                    }
                    self.showAlert(title: "Felicidades", message: "¡Tu oferta fue cargado con éxito!")
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
    }
    
    @IBAction func btnCalendario(_ sender: Any) {
        FechaAlertView.instance.showAlert()
        FechaAlertView.instance.selected = { fecha,hora in
            print("fecha y hora",fecha,hora)
        }
        tableView.isHidden = false
    }
    
    @IBAction func btnDocumento(_ sender: Any) {
    }
    
    @IBAction func btnUrl(_ sender: Any) {
        tableView.isHidden = false
        let ac = UIAlertController(title: "Ingresa una URL", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            print(answer)
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 6))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func btnImagen(_ sender: Any) {
        tableView.isHidden = false    
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch status{
            case .authorized:
                self.loadFromLibrary()
                break
            case .denied:
                self.pedirPermiso(titulo: "Debes habilitar permisos", mensaje: "Para modificar tu foto de perfil es necesario habilites los permisos", aceptar: "Otorgar permiso")
                break
            case .notDetermined:
                break
                
            case .restricted:
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
        let pref = UserDefaults()
        
        if let image = info[.originalImage] as? UIImage{
            //self.imgPerfil.image = image//UIImagePickerController.InfoKey.originalImage
            //saveImage(imageName:"\(pref.string(forKey: "nombreUsuario")!).png")
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnMetodoPago(_ sender: Any) {
        tableView.isHidden = false
        let ac = UIAlertController(title: "Ingresa una URL", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            print(answer)
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 11))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func btnTexto(_ sender: Any) {
        tableView.isHidden = false
       let ac = UIAlertController(title: "Ingresa una URL", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            print(answer)
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 13))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func btnRedes(_ sender: Any) {
        tableView.isHidden = false
        let ac = UIAlertController(title: "Ingresa una URL", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            print(answer)
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 12))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func btnVideo(_ sender: Any) {
    }
    
    @IBAction func btnPrecio(_ sender: Any) {
        tableView.isHidden = false
        let ac = UIAlertController(title: "Ingresa una URL", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 10))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func btnUbicacion(_ sender: Any) {
        tableView.isHidden = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! Post2TableViewCell
        cell.lblTexto.text = self.recursos[indexPath.row].valor
        if(self.recursos[indexPath.row].tipo == 3){
            cell.imgServicio.image = UIImage(named: "servicio_imagen")
        }  else if(self.recursos[indexPath.row].tipo == 4){
            cell.imgServicio.image = UIImage(named: "servicio_video")
        } else if(self.recursos[indexPath.row].tipo == 5){
            cell.imgServicio.image = UIImage(named: "servicio_documento")
        } else if(self.recursos[indexPath.row].tipo == 6){
            cell.imgServicio.image = UIImage(named: "servicio_enlace")
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
    
    func cargarHashTags(){
        txtHasTags.inputView = pickerViewHashTags
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.black
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor(red: 0.49411764705882, green: 0, blue: 0.49411764705882, alpha: 0)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed2) )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 13)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Selecciona:"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        txtHasTags.inputAccessoryView = toolBar
    }
    
    @objc func donePressed2() {
         print("Ingreso")
        if let index = intereses.firstIndex(of: self.busqueda?[pickerViewHashTags.selectedRow(inComponent: 0)].id ?? 0){
            print("No hay")
            intereses.remove(at: index)
            guardado?.remove(at: index)
        } else {
            print("Agregando")
            if(self.intereses.count >= 5){
                self.showAlert(title: "Ups", message: "Solo puedes agregar 5 hashtags")
               // self.enviarMensaje(titulo: "¡Ups!", mensaje: "Solo puedes agregar 5 hashtags")
            } else {
                intereses.append(self.busqueda?[pickerViewHashTags.selectedRow(inComponent: 0)].id ?? 0)
            }
        }
        txtHasTags.resignFirstResponder()
        collectionView.reloadData()
    }
    
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
    
    func cargarDatos(){
        print("load data:")
        let params = ["page_size":300]
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
        
    @IBAction func btnEmpelo(_ sender: Any) {
    }
    
    @IBAction func btnRegresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
     //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HashtagTableViewController
        vc.result = self.dato
        if segue.identifier == "triple"{
            vc.isTriple = true
        }
        vc.values = { val in
            self.view.endEditing(true)
            self.txtNombreServicio.resignFirstResponder()
            self.txtNombreServicio.text = "#\(val)"
        }
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
    
    @IBAction func showTripple(_ sender: Any) {
//        trippleButton.isHidden = true
//        self.performSegue(withIdentifier: "triple", sender: self)
    }
    @IBAction func phoneActivated(_ sender: Any) {
        txtTelefono.isEnabled = true
        txtTelefono.isHidden = false
    }
    @IBAction func locationActivated(_ sender: Any) {
        txtEstablecimiento.isEnabled = true
        txtEstablecimiento.isHidden = false 
    }
    
    @IBAction func setAddress(_ sender: Any) {
        present(GPSc ?? GooglePlacesSearchController(searchResultsController: nil), animated: true, completion: nil)
    }
    
    func viewController(didAutocompleteWith place: PlaceDetails) {
        print(place.description)
        GPSc?.isActive = false
        txtEstablecimiento.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
       // placesSearchController.isActive = false
    }
}
