//
//  PersonalizadoViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class PersonalizadoViewController: UIViewController {

    @IBOutlet weak var stcDos: UIStackView!
    @IBOutlet weak var viewUno: UIView!
    @IBOutlet weak var viewDos: BorderCardView!
    @IBOutlet weak var edtHashUno: UITextField!
    @IBOutlet weak var edtHashDos: UITextField!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    var varUno:Bool = true
    var varDos:Bool = true    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnContinuar(_ sender: Any) {
        //let pref = UserDefaults()
        if !(self.edtHashDos.text?.isEmpty ?? true){
            //let parametros = "tag=\(self.edtHashDos.text!)"
            NetworkLoader.loadData(url: Api.addExtra.url, data: ["tag":self.edtHashDos.text ?? ""], method: .post, completion: { (result:MyResult<VerifyCodeResponse>) in
            })
//            ws.wsToken(params: parametros, ws: "/usuarios/agregarExtra/", method: "POST", completion: {data in
//                DispatchQueue.main.async {
//                }
//            })
        }
        if !(self.edtHashUno.text?.isEmpty ?? true){
            NetworkLoader.loadData(url: Api.addExtra.url, data: ["tag":self.edtHashUno.text ?? ""], method: .post, completion: { (result:MyResult<VerifyCodeResponse>) in
            })
        }
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()
        self.view.window?.rootViewController = vc
    }
    
    
    @IBAction func btnAgregarUno(_ sender: Any) {
        
        if edtHashUno.text!.isEmpty{
            showAlert(title: "¡Ups!", message: "El campo no puede estar vacio")
        } else {
            //viewUno.isHidden = false
            label1.isHidden = false
            label1.text = edtHashUno.text
            button1.isHidden = true
           // lblTextoUno.text = edtHashUno.text!
        }
    }
    
    @IBAction func btnAgregarDOs(_ sender: Any) {
        
        if edtHashDos.text!.isEmpty{
            showAlert(title: "¡Ups!", message: "El campo no puede estar vacio")
        } else {
            label2.text = edtHashDos.text
            label2.isHidden = false
            button2.isHidden = false
            //viewDOs.isHidden = false
            //lblTextoDos.text = edtHashDos.text!
        }
    }
    
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func showtwo(_ sender: Any) {
        self.viewDos.isHidden = false
    }
    @IBAction func showOne(_ sender: Any) {
        self.viewUno.isHidden = false
    }
}
