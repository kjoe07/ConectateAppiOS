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
    
    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {

        // Creates a new UIView
        let titleView = UIView()

        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        let imageAspect = image.image!.size.width / image.image!.size.height
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height
        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        titleView.addSubview(label)
        titleView.addSubview(image)

        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()

        return titleView

    }
    func openWhatsApp(){
        DispatchQueue.main.async {
            let urlWhats = "whatsapp://send?phone=+5215579000450&text=Hola, puedes ayudarme con :"
            var characterSet = CharacterSet.urlQueryAllowed
             characterSet.insert(charactersIn: "?&")
             if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet){
                 if let whatsappURL = URL(string: urlString) {
                   if UIApplication.shared.canOpenURL(whatsappURL as URL){
                        UIApplication.shared.open(whatsappURL)
                   }else {
                       print("Install Whatsapp")
                   }
                }
            }
        }
    }
    func openWhatsApp(phone: String){
        DispatchQueue.main.async {
            let urlWhats = "whatsapp://send?phone=+\(phone)&text=Hola, :"
            var characterSet = CharacterSet.urlQueryAllowed
             characterSet.insert(charactersIn: "?&")
             if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet){
                 if let whatsappURL = URL(string: urlString) {
                   if UIApplication.shared.canOpenURL(whatsappURL as URL){
                        UIApplication.shared.open(whatsappURL)
                   }else {
                       print("Install Whatsapp")
                   }
                }
            }
        }
    }
}
protocol Identifier {
    static var identifier: String {get}
}
extension Identifier{
    static var indentifier: String{ return String(describing: self)}
}
extension UIViewController: Identifier {
    static var identifier: String {return String(describing: self)}
}
