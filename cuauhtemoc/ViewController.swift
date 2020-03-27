//
//  ViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/13/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
           
            let pref = UserDefaults();
            if let _ = pref.string(forKey: "token") {
                //mostrarDirecciones()
            
                if(pref.string(forKey: "bandera") == "0"){
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "perfilViewController") as! PerfilViewController
                    
                    self.present(viewController, animated: true, completion: nil)
                    
                } else if (pref.string(forKey: "bandera") == "1"){
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "interesesViewController") as! InteresesViewController
                    
                    self.present(viewController, animated: true, completion: nil)
                
                } else if (pref.string(forKey: "bandera") == "2"){
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "personalizadoViewController") as! PersonalizadoViewController
                    
                    self.present(viewController, animated: true, completion: nil)
                
                } else if (pref.string(forKey: "bandera") == "3"){
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
                    
                    self.present(viewController, animated: true, completion: nil)
                }
                
            } else {
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                
                self.present(viewController, animated: true, completion: nil)
            }
            
            
        }
    }


}
class AppCordinator{
    func nextViewController() -> UIViewController{
        let pref = UserDefaults();
        if let _ = pref.string(forKey: "token") {
            if(pref.string(forKey: "bandera") == "0"){
                return UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "perfilViewController") as! PerfilViewController
            } else if (pref.string(forKey: "bandera") == "1"){
                return UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "interesesViewController") as! InteresesViewController
            } else if (pref.string(forKey: "bandera") == "2"){
                return UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "personalizadoViewController") as! PersonalizadoViewController
            } else if (pref.string(forKey: "bandera") == "3"){
                return UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
            }
        } else {
            return UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        }
        return ViewController()
    }
}
