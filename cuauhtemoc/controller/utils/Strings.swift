//
//  Strings.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/14/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import UIKit


class Strings {
    
    var ws = "http://conectateyempleate.com"
    var appName = "Cuauhtemoc"
    var rutaImagen = "https://pruebaflight.s3.amazonaws.com"
    
    var titulo_error = "¡Ups!"
    var mensaje_error_campos = "Es necesario ingresar todos los datos para continuar"
    var dispositivo = "ios"
    static var interfaz = "2"
    
}


let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}
