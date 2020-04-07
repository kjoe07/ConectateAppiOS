//
//  OfrecerTruequeViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class OfrecerTruequeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var textFields: [UITextField]!
    var post:Contenido!
    var perfil:PerfilCompleto!
    var descripcion:[Intereses]! = []
    
    @IBOutlet weak var txtPerfil: UITextField!
    @IBOutlet weak var txtOfreces: UITextField!
    @IBOutlet weak var txtCambio: UITextField!
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPerfil.delegate = self
        txtOfreces.delegate = self
        txtCambio.delegate = self
        
        pickerView.delegate = self
        
        textFields = [txtPerfil, txtOfreces, txtCambio];
        cargarDatos()
    }
    
    @IBAction func btnHacerTrueque(_ sender: Any) {
        
        if(validarDatos(textFields: textFields)){
            
            wsAccion(tipo: "4",post: self.post.id,cuerpo: "\(self.txtOfreces.text!)|\(self.txtCambio.text!)")
        }
        
        
        
    }
    
    
    
    func validarDatos(textFields: [UITextField]) -> Bool{
        
        for textField in textFields {
            if (textField.text?.isEmpty)!{
                enviarMensaje(titulo: "¡Ups!", mensaje: "Todos los campos para continuar")
                return false;
            }
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func wsAccion(tipo:String, post:Int, cuerpo:String ){
        
        let ws = WebServiceClient()
        let params = "tipo=\(tipo)&post=\(post)&cuerpo=\(cuerpo)"
        
        
        DispatchQueue.main.async {
            ws.wsToken(params: params, ws: "/contenido/acciones/add", method: "POST", completion: { data in
               
                
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
    
    func enviarMensajeVista( titulo:String, mensaje:String){
        
        let btnAlert = UIAlertController(title: titulo, message:mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ContenidoViewController") as! ContenidoViewController
            
            self.present(viewController, animated: true, completion: nil)
            
        }
        
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
    
    func cargarDatos(){
        
        let ws = WebServiceClient()
        
        DispatchQueue.main.async {
            ws.wsTokenArray(params: "", ws: "/usuarios/verPerfil/", method: "GET", completion: { data in
                
                do {
                    self.perfil = try JSONDecoder().decode(PerfilCompleto.self, from: data as! Data)
                    self.descripcion.append(contentsOf: self.perfil.perfil.descripcion)
                    
                    DispatchQueue.main.async {
                        self.cargarHashTags()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            })
        }
    }
    
    func cargarHashTags(){
        
        txtPerfil.inputView = pickerView
        
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
        txtPerfil.inputAccessoryView = toolBar
    }
    
    @objc func donePressed2() {
        
        print("Ingreso")
        txtPerfil.resignFirstResponder()
        txtPerfil.text = descripcion[pickerView.selectedRow(inComponent: 0)].tag
        //txtHasTags.text = busqueda[pickerViewHashTags.selectedRow(inComponent: 0)]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.descripcion.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.descripcion![row].tag
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
