//
//  CargarOfertaViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/24/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
import CheckBox

class CargarOfertaViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lblTipoServicio: UITextField!
    @IBOutlet weak var txtNombreServicio: UITextField!
    @IBOutlet weak var txtHasTags: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    @IBOutlet weak var ckbTelefono: CheckBox!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtEstablecimiento: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var pickerViewServicio = UIPickerView()
    var pickerViewHashTags = UIPickerView()
    var recursos:[Recurso]!  = []
    
    var tipoServicio:[String] = ["Empleo","Servicio","Establecimiento", "Evento", "Producto"]
    
    var dato:[Intereses] = []
    var busqueda:[Intereses] = []
    var intereses:[Int] = []
    var guardado:[Intereses] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTipoServicio.delegate = self
        txtNombreServicio.delegate = self
        txtHasTags.delegate = self
        txtDescripcion.delegate = self
        txtTelefono.delegate = self
        txtEstablecimiento.delegate = self
        
        pickerViewServicio.delegate = self
        pickerViewHashTags.delegate = self
        
        cargarServicio()
        cargarDatos()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    @IBAction func btnAgregar(_ sender: Any) {
        
        let ws = WebServiceClient()
        
        let params = "titulo=\(self.txtNombreServicio.text!)&tipo=\(pickerViewServicio.selectedRow(inComponent: 0)+1)&body=\(self.txtDescripcion.text!)&flag_telefono=true"
        DispatchQueue.main.async {
            ws.wsToken(params: params, ws: "/contenido/add_post/", method: "POST", completion: {data in
                
                 let res = data.object(forKey: "id") as! Int
               
                DispatchQueue.main.async {
                    
                    for i in 0...self.guardado.count-1 {
                        self.agregarKeyword(post: res,keyword: self.guardado[i].id)
                    }
                    
                     for i in 0...self.recursos.count-1 {
                        
                        if(self.recursos[i].tipo == 3){
                            
                                   
                        }  else if(self.recursos[i].tipo == 4){
                      
                                   
                        } else if(self.recursos[i].tipo == 5){
                           
                                   
                        } else if(self.recursos[i].tipo == 6){
                            self.subirURL(post: res, valor: self.recursos[i].valor, url: "add_url")
                            
                        } else if(self.recursos[i].tipo == 8){
                            
                            self.subirURL(post: res, valor: self.recursos[i].valor, url: "add_fecha")
                            
                        } else if(self.recursos[i].tipo == 9){
                        
                      
                            
                        } else if(self.recursos[i].tipo == 10){
                            self.subirURL(post: res, valor: self.recursos[i].valor, url: "add_precio")
                            
                        } else if(self.recursos[i].tipo == 11){
                            self.subirText(post: res, valor: self.recursos[i].valor, tipo: self.recursos[i].tipo)
                        
                        } else if(self.recursos[i].tipo == 12){
                            self.subirText(post: res, valor: self.recursos[i].valor, tipo: self.recursos[i].tipo)
                            
                        } else if(self.recursos[i].tipo == 13){
                            self.subirText(post: res, valor: self.recursos[i].valor, tipo: self.recursos[i].tipo)
                        
                        }
                        
                    }
                    
                    self.enviarMensaje(titulo: "Felicidades", mensaje: "¡Tu oferta fue cargado con éxito!")
                    
                }
            })
        }
    }
    
    @IBAction func btnCalendario(_ sender: Any) {
        FechaAlertView.instance.showAlert()
    }
    
    @IBAction func btnDocumento(_ sender: Any) {
    }
    
    @IBAction func btnUrl(_ sender: Any) {
        
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
        
       
    }
    
    @IBAction func btnMetodoPago(_ sender: Any) {
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
        
        let ac = UIAlertController(title: "Ingresa una URL", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Agregar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text!
            print(answer)
            self.recursos.append(Recurso(id: 0, orden: 0, post: 0, valor: answer, tipo: 10))
            self.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    @IBAction func btnUbicacion(_ sender: Any) {
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! PostTableViewCell
        
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
        
        if let index = intereses.firstIndex(of: self.busqueda[pickerViewHashTags.selectedRow(inComponent: 0)].id){
            print("No hay")
            intereses.remove(at: index)
            guardado.remove(at: index)
        } else {
            print("Agregando")
            if(self.intereses.count >= 5){
                self.enviarMensaje(titulo: "¡Ups!", mensaje: "Solo puedes agregar 5 hashtags")
            } else {
                guardado.append(self.busqueda[pickerViewHashTags.selectedRow(inComponent: 0)])
                intereses.append(self.busqueda[pickerViewHashTags.selectedRow(inComponent: 0)].id)
            }
        }
        print(guardado.count)
        txtHasTags.resignFirstResponder()
        collectionView.reloadData()
        //txtHasTags.text = busqueda[pickerViewHashTags.selectedRow(inComponent: 0)]
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
            return busqueda.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerViewServicio {
            return tipoServicio[row]
            
        } else if pickerView == pickerViewHashTags {
            return busqueda[row].tag
        }
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guardado.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/3.0)-5, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "simpleHashCollectionViewCell", for: indexPath) as! SimpleHashCollectionViewCell
        
        cell.txtHashTags.text = "#\(guardado[indexPath.row].tag!)"
        
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
        guardado.remove(at: indexPath.row)
        self.collectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.busqueda.removeAll()
        if(self.txtHasTags.text! == ""){
            self.busqueda.append(contentsOf: self.dato)
        } else {
            for i in 0...self.dato.count-1 {
                if(self.dato[i].tag.lowercased().contains(self.txtHasTags.text!)){
                    busqueda.append(self.dato[i])
                    print("Busqueda \(busqueda.count)")
                    //self.collectionView.reloadData()
                    pickerViewHashTags.reloadAllComponents()
                }
            }
        }
        return true
    }
    
    func cargarDatos(){
        
        let ws = WebServiceClient()
        
        DispatchQueue.main.async {
            ws.wsToken(params: "", ws: "/clasificador/listHastTagKetwords/?page_size=300", method: "GET", completion: {data in
                
                let algo = data.object(forKey: "results") as! NSArray
                for val in algo {
                    
                    let item = val as! NSDictionary
                    self.dato.append(Intereses(id: item.object(forKey: "id") as! Int, tipo: item.object(forKey: "tipo") as! Int, tag: item.object(forKey: "tag") as! String, imagen: item.object(forKey: "imagen") as! String))
                }
                print(self.dato.count)
                self.busqueda.append(contentsOf: self.dato)
                self.cargarHashTags()
                DispatchQueue.main.async {
                    
                }
            })
        }
    }
    
    func enviarMensaje( titulo:String, mensaje:String){
        
        let btnAlert = UIAlertController(title: titulo, message:mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
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
    
    func agregarKeyword(post:Int, keyword:Int){
        
        let ws = WebServiceClient()
        let parametros = "post=\(post)&keyword=\(keyword)"

        DispatchQueue.main.async {
            
            ws.wsToken(params: parametros, ws: "/contenido/add_keyword_post/", method: "POST", completion: {data in
        
            })
        }
    }
    
    func subirText(post:Int, valor:String, tipo:Int){
        
        let ws = WebServiceClient()
        let parametros = "post=\(post)&valor=\(valor)&tipo=\(tipo)"

        DispatchQueue.main.async {
            
            ws.wsToken(params: parametros, ws: "/contenido/add_texto/", method: "POST", completion: {data in
        
            })
        }
    }
    
    func subirURL(post:Int, valor:String, url:String){
        
        let ws = WebServiceClient()
        let parametros = "post=\(post)&valor=\(valor)"

        DispatchQueue.main.async {
            
            ws.wsToken(params: parametros, ws: "/contenido/\(url)/", method: "POST", completion: {data in
        
            })
        }
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
