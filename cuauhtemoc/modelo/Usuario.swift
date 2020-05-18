//
//  Usuario.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


struct Usuario:Codable {
    var id:Int?
    var nombre:String?
    var apellido:String?
    var celular:String?
    var fecha_nacimiento:String?
    var cp:String?
    var image:String?
    
//    init(id:Int, nombre:String, apellido:String, celular:String, fecha_nacimiento:String, cp:String) {
//
//        self.id = id
//        self.nombre = nombre
//        self.apellido = apellido
//        self.celular = celular
//        self.fecha_nacimiento = fecha_nacimiento
//        self.cp = cp
//    }
}

struct LoginResponse:Codable {
    let result: Int?
    let token: String?
    let usuario: Usuario?
    let error: String?
    let code_verification:Int?
}
