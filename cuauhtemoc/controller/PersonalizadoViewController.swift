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
    @IBOutlet weak var stcDos: UIStackView!
    @IBOutlet weak var viewUno: UIView!
    @IBOutlet weak var edtHashUno: UITextField!
    @IBOutlet weak var edtHashDos: UITextField!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    
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
        viewUno.isHidden = true
       // stcUno.isHidden = true
        stcDos.isHidden = true
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
            imgUno.isHidden = true
            viewUno.isHidden = false
            label1.isHidden = false
            label1.text = edtHashUno.text
           // lblTextoUno.text = edtHashUno.text!
        }
    }
    
    @IBAction func btnAgregarDOs(_ sender: Any) {
        
        if edtHashDos.text!.isEmpty{
            showAlert(title: "¡Ups!", message: "El campo no puede estar vacio")
        } else {
            imgDos.isHidden = true
            label2.text = edtHashDos.text
            label2.isHidden = false
            //viewDOs.isHidden = false
            //lblTextoDos.text = edtHashDos.text!
        }
    }
    
    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        
        if(varUno){
           // stcUno.isHidden = false
            varUno = false
        } else {
            //stcUno.isHidden = true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
