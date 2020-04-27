//
//  Notificacion.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

struct Notificacion :Codable {
    
    var id:Int?
    var usuario:Int?
    var usuario_envio:Int?
    var interfaz:Int?
    var tipo:Int?
    var cuerpo:String?
    var estatus:Bool?
    var fecha:String?
    var content_object: DatoComentario?
}
