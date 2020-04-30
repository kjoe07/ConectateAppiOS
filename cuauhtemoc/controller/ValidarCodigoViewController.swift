//
//  ValidarCodigoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/16/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ValidarCodigoViewController: UIViewController, UITextFieldDelegate {
    
    var telefono:String!
    var scrollGestureRecognizer: UITapGestureRecognizer!
    var textFields: [UITextField]!
    let strings = Strings()
    var user: Usuario?
    @IBOutlet weak var txtCodigo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargaInit()
        txtCodigo.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClick))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        txtCodigo.inputAccessoryView = toolbar
        let userdata = UserDefaults.standard.object(forKey: "usuario") as! Data
        let user = try? JSONDecoder().decode(Usuario.self, from: userdata)
        telefono = (user?.celular?.hasPrefix("+52") ?? false) ? (user?.celular?.replacingOccurrences(of: "+52", with: "") ?? "") : ("\(user?.celular ?? "")")
        print("phone is :",telefono)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnReenviarCodigo(_ sender: Any) {
        reenviarCodigo()
    }
    
    @IBAction func btnValidarCodigo(_ sender: Any) {
        
        if(validarDatos(textFields: textFields)){
            validarCodigo()
        }
    }
    
    func validarCodigo(){
        let params = ["codigo":self.txtCodigo.text ?? "","telefono":self.telefono,"interfaz":Strings.interfaz]
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.verifyCode.url, data: params, method: .post, completion: {[weak self] (result: MyResult<VerifyCodeResponse>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(let dat):
                    if dat.result ?? 0  == 1{
                        if !KeychainService.savePassword(service: "cuauhtemoc", account: "token", data: dat.token ?? ""){
                            KeychainService.updatePassword(service: "cuauhtemoc", account: "token", data: dat.token ?? "")
                        }else{
                            print("something wrong heppen")
                        }
                        self.performSegue(withIdentifier: PerfilViewController.identifier, sender: self)
                    }else if dat.result ?? -1 == 0{
                        self.showAlert(title: "¡Ups!", message: "No existe el usuario al que se solicitó este código")
                    }else if dat.result ?? 0 == -1 {
                        self.showAlert(title: "¡Ups!", message: "El código que ingresaste no es valido")
                    }else{
                        self.showAlert(title: "Ups.", message: "Algo salió mal, por favor inténtalo nuevamente. Si el problema persiste envía un correo a soporte@fligthcapital.com")
                    }
                case .failure(let e):
                    self.showAlert(title: "Ups!", message: e.localizedDescription)
                }
            }
        })
        
//        let ws = WebServiceClient();
//        let pref = UserDefaults();
//
//         DispatchQueue.main.async {
//
//            let params = "codigo=\(self.txtCodigo.text!)&telefono=\(self.telefono!)&interfaz=\(self.Strings.interfaz)"
//
//            ws.wsGenericoPost(params: params, ws: "/usuarios/verificarCodigo/", method: "POST", completion: {data in
//
//                let res = data.object(forKey: "result") as! Int
//
//                if res > 0 {
//
//                    pref.setValue(data.object(forKey: "token") as! String, forKey: "token")
//                    pref.setValue("0", forKey: "bandera")
//
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "perfilViewController") as! PerfilViewController
//
//                    self.present(viewController, animated: true, completion: nil)
//
//                } else if res == 0 {
//                    self.enviarMensaje(titulo: )
//
//                } else if res == -1 {
//                    self.enviarMensaje(titulo: "¡Ups!", mensaje: "El código que ingresaste no es valido")
//
//                } else{
//                    self.enviarMensaje(titulo: "¡Ups!", mensaje: )
//                }
//            })
//        }
    }
    
    func reenviarCodigo(){
        let params = ["telefono": telefono]
        showActivityIndicator(color: .green)
        NetworkLoader.loadData(url: Api.sendCode.url, data: params, method: .post, completion: { [weak self] (result: MyResult<SendCodeResponse>) in
            DispatchQueue.main.async {
                guard let self =  self else {return}
                self.hideActivityIndicator()
                switch result{
                case .success(dat: let dat):
                    if dat.result ?? 0 == 1{
                        self.showAlert(title: "", message: "El codigo fue enviado satisfactoriamente")
                    }else{
                        self.showAlert(title: "", message: dat.error ?? "No se pudo enviar el codigo intente mas tarde")
                    }
                case .failure(let e):
                    self.showAlert(title: "", message: e.localizedDescription /*?? "No se pudo enviar el codigo intente mas tarde"*/)
                }
            }
        })
    }
    
    func cargaInit(){
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        scrollGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        
        textFields = [txtCodigo];
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
                enviarMensaje(titulo: "¡Ups!", mensaje: "Ingrese el código para continuar")
                return false;
            }
        }
        
        return true
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
