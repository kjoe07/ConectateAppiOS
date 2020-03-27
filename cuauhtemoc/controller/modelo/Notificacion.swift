//
//  Notificacion.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class Notificacion:Codable {
    
    var id:Int!
    var usuario:Int!
    var usuario_envio:Int!
    var interfaz:Int!
    var tipo:Int!
    var cuerpo:String!
    var estatus:Bool!
    var fecha:String!
    var content_object:DatoComentario
    
    init(id:Int, usuario:Int, usuario_envio:Int, interfaz:Int, tipo:Int, cuerpo:String, estatus:Bool, fecha:String, content_object:DatoComentario  ) {
        
        self.id = id
        self.usuario = usuario
        self.usuario_envio = usuario_envio
        self.interfaz = interfaz
        self.tipo = tipo
        self.cuerpo = cuerpo
        self.fecha = fecha
        self.estatus = estatus
        self.content_object = content_object
    }
}
