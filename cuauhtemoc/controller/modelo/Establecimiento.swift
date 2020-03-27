//
//  Establecimiento.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class Establecimiento:Codable {
    
    var id:Int!
    var usuario:Int!
    var nombre:String!
    
    var latitud:String!
    var longitud:String!
    var direccion:String!
    var estatus:Bool!
    var interfaz:Int!
    
     init(id:Int, usuario:Int, nombre:String, latitud:String, longitud:String, direccion:String, estatus:Bool, interfaz:Int) {
        
        self.id = id
        self.usuario = usuario
        self.nombre = nombre
        self.latitud = latitud
        self.longitud = longitud
        self.direccion = direccion
        self.estatus = estatus
        self.interfaz = interfaz
        
    }
    
}
