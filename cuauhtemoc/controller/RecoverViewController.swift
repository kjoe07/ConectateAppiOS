//
//  RecoverViewController.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/16/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit

class RecoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var email: UITextField!
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: BorderCurvedButton) {
        if email.text != "" && email.isEmail(){
            let params = ["email": email.text ?? ""]
            NetworkLoader.loadData(url: Api.recoverPassword.url, data: params, method: .post, completion: {[weak self] (result:MyResult<LoginResponse?>) in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    switch result{
                    case .success(dat: let data):
                        if data?.result == 1{
                            self.showAlert(title: "", message: "En breve recivirá un correo electronico con instrucciones para recuperar su contraseña.")
                        }else{
                            self.showAlert(title: "Ups!", message: "No pudimos enviarle el correo electronico, intente más tarde por favor.")
                        }
                    case .failure(let e):
                        self.showAlert(title: "Ups!", message: e.localizedDescription)
                    }
                }
            })
        }else{
            self.showAlert(title: "Ups!", message: "la direccion de correo no es válida.")
        }
    }
    
}
