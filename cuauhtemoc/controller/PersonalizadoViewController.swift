//
//  PersonalizadoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class PersonalizadoViewController: UIViewController {

    @IBOutlet weak var imgUno: UIImageView!
    @IBOutlet weak var imgDos: UIImageView!
    
    @IBOutlet weak var stcUno: UIStackView!
    @IBOutlet weak var stcDos: UIStackView!
    
    @IBOutlet weak var viewUno: UIView!
    @IBOutlet weak var viewDOs: UIView!
    
    @IBOutlet weak var edtHashUno: UITextField!
    @IBOutlet weak var edtHashDos: UITextField!
    
    @IBOutlet weak var lblTextoUno: UILabel!
    @IBOutlet weak var lblTextoDos: UILabel!
    
    var varUno:Bool = true
    var varDos:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgUno.isUserInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTapping(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        imgUno.addGestureRecognizer(singleTap)
        
        imgDos.isUserInteractionEnabled = true
        let singleTapDos: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTappingDos(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        imgDos.addGestureRecognizer(singleTapDos)
        
        stcUno.isHidden = true
        stcDos.isHidden = true
    }
    
    @IBAction func btnContinuar(_ sender: Any) {        
        let ws = WebServiceClient()
        let pref = UserDefaults()
        if !(self.edtHashDos.text?.isEmpty ?? true){
            let parametros = "tag=\(self.edtHashDos.text!)"
            ws.wsToken(params: parametros, ws: "/usuarios/agregarExtra/", method: "POST", completion: {data in
                DispatchQueue.main.async {
                }
            })
        }
        if !(self.edtHashUno.text?.isEmpty ?? true){
            let parametros = "tag=\(self.edtHashUno.text!)"
            ws.wsToken(params: parametros, ws: "/usuarios/agregarExtra/", method: "POST", completion: {data in
                DispatchQueue.main.async {
                }
            })
        }
        
        pref.setValue("3", forKey: "bandera")
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnAgregarUno(_ sender: Any) {
        
        if edtHashUno.text!.isEmpty{
            enviarMensaje(titulo: "¡Ups!", mensaje: "El campo no puede estar vacio")
        } else {
            imgUno.isHidden = true
            viewUno.isHidden = false
            lblTextoUno.text = edtHashUno.text!
        }
    }
    
    @IBAction func btnAgregarDOs(_ sender: Any) {
        
        if edtHashDos.text!.isEmpty{
            enviarMensaje(titulo: "¡Ups!", mensaje: "El campo no puede estar vacio")
        } else {
            imgDos.isHidden = true
            viewDOs.isHidden = false
            lblTextoDos.text = edtHashDos.text!
        }
    }
    
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        
        if(varUno){
            stcUno.isHidden = false
            varUno = false
        } else {
            stcUno.isHidden = true
            varUno = true
        }
    }
    
    @objc func singleTappingDos(recognizer: UIGestureRecognizer) {
        
        if(varDos){
            stcDos.isHidden = false
            varDos = false
        } else {
            stcDos.isHidden = true
            varDos = true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
