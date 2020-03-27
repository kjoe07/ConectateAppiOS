//
//  Accion.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/23/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class Accion:Codable {

    var id:Int!
    var tipo:Int!
    var post:Int!
    var cuerpo:String!
    var estatus:Int!
    var nombre_usuario:String!
    var nombre_post:String!
    var titulo_post:String!
    var fecha:String!
    var calificacion:Int!
    
    
    init(id:Int, tipo:Int, post:Int, cuerpo:String, estatus:Int, nombre_usuario:String, nombre_post:String, titulo_post:String, fecha:String, calificacion:Int  ) {
        
        self.id = id
        self.tipo = tipo
        self.post = post
        self.cuerpo = cuerpo
        self.estatus = estatus
        self.nombre_usuario = nombre_usuario
        self.nombre_post = nombre_post
        self.titulo_post = titulo_post
        self.fecha = fecha
        self.calificacion = calificacion
    }
    
    
}
