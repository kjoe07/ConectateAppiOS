//
//  LoginViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/14/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit
import Firebase
import ActivityIndicator
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var scrollGestureRecognizer: UITapGestureRecognizer!
    var textFields: [UITextField]!
    let strings = Strings()
    var googleID:String?
    
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // [END log_fcm_reg_token]
        
        // [START log_iid_reg_token]
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.googleID = result.token
            }
        }
        
        //cargaInit()
        
        txtCorreo.delegate = self
        txtPassword.delegate = self
        
        textFields = [txtCorreo, txtPassword];
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if(validarDatos(textFields: textFields)){
            self.loginUsuarioWS()
        }
    }
    
    @IBAction func btnRegistrate(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "registroViewController") as! RegistroViewController
        viewController.googleID = self.googleID
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    func loginUsuarioWS(){
        let params = ["email": txtCorreo.text ?? "","password":txtPassword.text ?? "","googleid":googleID ?? "assdwqdsa","dispositivo":"ios","interfaz":"2"]
        self.showActivityIndicator(color: UIColor(named: "green") ?? .green)
        NetworkLoader.loadData(url: Api.login.url, data: params, method: .post, completion: {[weak self] (result: MyResult<LoginResponse>) in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else{return}
                self.hideActivityIndicator()
                print("resul:",result)
                switch result{
                case .success(let dat):
                    if dat.result ?? 0 == 0 {
                        self.showAlert(title: "¡Ups!", message: dat.error ?? "")
                    }else if dat.result ?? 0 == 1{
                        print("is greater than 0")
                        if !KeychainService.savePassword(service: "cuauhtemoc", account: "token", data: dat.token ?? ""){
                            KeychainService.updatePassword(service: "cuauhtemoc", account: "token", data: dat.token ?? "")
                        }
                        let encoder = try? JSONEncoder().encode(dat.usuario)
                        UserDefaults.standard.set(encoder, forKey: "usuario")
                        UserDefaults.standard.synchronize()
                        self.view.window?.rootViewController = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()
                        //self.view.window?.makeKeyAndVisible()
                    }else if dat.result ?? 0 == 2{
                        let encoder = try? JSONEncoder().encode(dat.usuario)
                        UserDefaults.standard.set(encoder, forKey: "usuario")
                        self.performSegue(withIdentifier: ValidarCodigoViewController.identifier, sender: self)
                        //let vc = self.storyboard?.instantiateViewController(identifier: ValidarCodigoViewController.identifier) as! ValidarCodigoViewController
                        //self.present(vc, animated: true, completion: nil)
                    }else if dat.result ?? 0 == 3{
                        let vc = self.storyboard?.instantiateViewController(identifier: PerfilViewController.identifier) as! PerfilViewController
                        self.present(vc, animated: true, completion: nil)
                    }else if dat.result ?? 0 == 4 {
                        let vc = self.storyboard?.instantiateViewController(identifier: InteresesViewController.identifier) as! InteresesViewController
                        self.present(vc, animated: true, completion: nil)
                    }else if dat.result ?? 0 == 5{
                        self.showAlert(title: "¡Ups!", message: "usuario y/o contraseña incorrectos")
//                        let vc = self.storyboard?.instantiateViewController(identifier: PersonalizadoViewController.identifier) as! PersonalizadoViewController
//                        self.present(vc, animated: true, completion: nil)
                    }
                    
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
//        let ws = WebServiceClient();
//        let pref = UserDefaults();
//
//
//            ws.login(mail: self.txtCorreo.text!, pass: self.txtPassword.text!, googleId: self.googleID,  completion: {data in
//                DispatchQueue.main.async {
//                    self.hideActivityIndicator()
//                    let res = data.object(forKey: "result") as! Int
//
//                    if res > 0 {
//                        let token = data.object(forKey: "token") as? String
//
//                        let res1 = data.object(forKey: "usuario") as! NSDictionary
//                        let idUsuario =  (res1 as AnyObject).object(forKey: "id")! as? Int
//                        let nombre =  (res1 as AnyObject).object(forKey: "nombre")! as? String
//                        let apellido =  (res1 as AnyObject).object(forKey: "apellido")! as? String
//                        let celular =  (res1 as AnyObject).object(forKey: "celular")! as? String
//                        pref.setValue(idUsuario, forKey: "idUsuario")
//                        pref.setValue("\(nombre ?? "") \(apellido ?? "")", forKey: "nombreUsuario")
//                        pref.setValue(self.txtCorreo.text, forKey: "mailUsuario")
//                        pref.setValue(celular, forKey: "celUsuario")
//                        pref.setValue(token, forKey: "token")
//                        pref.setValue("3", forKey: "bandera")
//
//                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
//                        self.present(controller, animated: true, completion: nil)
//                    }else{
//                        print("ocurrio un error",data.object(forKey: "error") as? String ?? "")
//                        self.showAlert(title: "Ups!", message: data.object(forKey: "error") as? String ?? "" )
//                    }
//                }
//            })
//
    }
    
//    func cargaInit(){
//
//        let center: NotificationCenter = NotificationCenter.default
//        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        scrollGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
//
//        textFields = [txtCorreo, txtPassword];
//
//    }
    
    @objc func hideKeyBoard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtCorreo.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//
//        if(UIDevice.current.userInterfaceIdiom == .pad){
//
//        }else {
//            self.view.layoutIfNeeded()
//        }
//    }
    
    func validarDatos(textFields: [UITextField]) -> Bool{
        
        for textField in textFields {
            if (textField.text?.isEmpty)!{
                enviarMensaje(titulo: "¡Ups!", mensaje: "Ingrese correo y contraseña para continuar")
                return false;
            }
            
            if(textField == txtCorreo && isValidEmail(emailStr: self.txtCorreo.text!)){
                return true
            } else {
                enviarMensaje(titulo: "¡Ups!", mensaje: "El formato del correo es inválido, ingresa correctamente tu correo para contiuar")
                return false
            }
        }
        return true
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func enviarMensaje( titulo:String, mensaje:String){
        
        let btnAlert = UIAlertController(title: titulo, message:mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        
        btnAlert.addAction(okAction)
        self.present(btnAlert, animated: true, completion: nil)
    }
}
