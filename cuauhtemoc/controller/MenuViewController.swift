//
//  MenuViewController.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/14/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
