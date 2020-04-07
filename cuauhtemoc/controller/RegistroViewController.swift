//
//  RegistroViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/14/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
import CheckBox

class RegistroViewController: UIViewController, UITextFieldDelegate {
    
    var scrollGestureRecognizer: UITapGestureRecognizer!
    var textFields: [UITextField]!
    let strings = Strings()

    var googleID:String!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPassword2: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var txtFechaNacimiento: UITextField!
    @IBOutlet weak var chcDatos: CheckBox!
    @IBOutlet weak var chcTerminos: CheckBox!
    
    @IBOutlet weak var txtEstablecimiento: UITextField!
    
    var fechaPickerView = UIDatePicker()
    var fechaString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargaInit()
        
        txtNombre.delegate = self
        txtTelefono.delegate = self
        txtCorreo.delegate = self
        txtPassword.delegate = self
        txtPassword2.delegate = self
        txtCP.delegate = self
        txtFechaNacimiento.delegate = self
        txtEstablecimiento.delegate = self
        
        fechaPickerView.datePickerMode = UIDatePicker.Mode.date
        fechaPickerView.locale = Locale.init(identifier: "es_MX")
    
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClick))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        txtTelefono.inputAccessoryView = toolbar
        txtCP.inputAccessoryView = toolbar
        
        cargarFecha()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnRegistro(_ sender: Any) {
        
        if(validarDatos(textFields: textFields)){
            registroUsuarioWS()
        }
    }
    
    func registroUsuarioWS(){
        let ws = WebServiceClient()
        let pref = UserDefaults()
        ws.registro(mail: self.txtCorreo.text!, pass: self.txtPassword.text!, nombre: self.txtNombre.text!, apellido: self.txtApellido.text!, celular: "52\(self.txtTelefono.text!)", fecha: self.fechaString, cp: self.txtCP.text!, googleId: self.googleID, completion: { data in
            
            let res = data.object(forKey: "result") as? Int
            
            if res ?? 0 == 1 {
                let token = data.object(forKey: "token") as? String
                
                let res1 = data.object(forKey: "usuario") as! NSDictionary
                
                let idUsuario =  (res1 as AnyObject).object(forKey: "id")! as? Int
                let nombre =  (res1 as AnyObject).object(forKey: "nombre")! as? String
                let apellido =  (res1 as AnyObject).object(forKey: "apellido")! as? String
                let celular =  (res1 as AnyObject).object(forKey: "celular")! as? String
                
                pref.setValue(idUsuario, forKey: "idUsuario")
                pref.setValue(nombre ?? "", forKey: "nombreUsuario")
                pref.setValue(apellido ?? "", forKey: "mailUsuario")
                pref.setValue(celular ?? "", forKey: "celUsuario")
                pref.setValue(token, forKey: "token")
                pref.setValue(self.txtPassword.text, forKey: "password")
                pref.setValue(self.txtCP.text!, forKey: "cp")
                DispatchQueue.main.async {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "validarCodigoViewController") as! ValidarCodigoViewController
                    controller.telefono = "52\(self.txtTelefono.text!)"
                    self.present(controller, animated: true, completion: nil)
                }
                
            } else {
                self.enviarMensaje(titulo: "¡Ups!", mensaje: "Ya existe un usuario registrado con esos datos, intenta iniciar sesión o recuperar contraseña.")
            }
        })
        
    }
    
    func cargarFecha(){
        
        txtFechaNacimiento.inputView = fechaPickerView
        
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
        label.text = "Selecciona una fecha:"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,doneButton], animated: true)
        txtFechaNacimiento.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        txtFechaNacimiento.resignFirstResponder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "dd MMM YYY"
        let fechaFormater1 = dateFormatter.string(from: (fechaPickerView.date))
        txtFechaNacimiento.text = fechaFormater1
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        fechaString = dateFormatter.string(from: (fechaPickerView.date))
    }
    
    
    func cargaInit(){
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        scrollGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        
        textFields = [txtNombre, txtApellido, txtTelefono, txtCorreo, txtPassword, txtPassword2, txtCP, txtFechaNacimiento ];
    }
    
    @objc func doneClick(){
        view.endEditing(true)
    }
    
    @objc func hideKeyBoard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if(UIDevice.current.userInterfaceIdiom == .pad){
            
        }else {
            self.view.layoutIfNeeded()
        }
    }
    
    func validarDatos(textFields: [UITextField]) -> Bool{
        
        for textField in textFields {
            if (textField.text?.isEmpty)!{
                enviarMensaje(titulo: "¡Ups!", mensaje: "Ingrese todos los campos para continuar")
                return false;
            }
        }
        
        if(txtPassword.text == txtPassword2.text){
            
        } else {
            enviarMensaje(titulo: "Verifica tu información", mensaje: "Las contraseñas deben de coincidir para continuar")
            return false
        }
        
        if(chcDatos.isChecked && chcTerminos.isChecked){
            return true
        } else {
            enviarMensaje(titulo: "Verifica tu información", mensaje: "Debes aceptar términos y coindiciones y la ley de datos personale spara continuar")
            return false
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
