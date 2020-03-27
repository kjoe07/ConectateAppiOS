//
//  Usuario.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class Usuario:Codable {
    
    var id:Int!
    var nombre:String!
    var apellido:String!
    var celular:String!
    var fecha_nacimiento:String!
    var cp:String!
    
    init(id:Int, nombre:String, apellido:String, celular:String, fecha_nacimiento:String, cp:String) {
        
        self.id = id
        self.nombre = nombre
        self.apellido = apellido
        self.celular = celular
        self.fecha_nacimiento = fecha_nacimiento
        self.cp = cp
    }

}
