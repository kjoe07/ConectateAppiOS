//
//  UIViewControllerExtension.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 3/27/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import UIKit
extension UIViewController{
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
