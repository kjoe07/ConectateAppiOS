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
                            self.showAlert(title: "¡LISTO!", message: "Revisa tu correo electrónico, te enviamos las instrucciones que debes seguir para recuperar tu contraseña")
                        }else{
                            self.showAlert(title: "Ups!", message: "No pudimos enviarle el correo electronico, intente más tarde por favor.")
                        }
                    case .failure(let e):
                        self.showAlert(title: "Ups!", message: e.localizedDescription)
                    }
                }
            })
        }else{
            self.showAlert(title: "", message: "Es necesario el correo electrónico para continuar")
        }
    }
    
}
