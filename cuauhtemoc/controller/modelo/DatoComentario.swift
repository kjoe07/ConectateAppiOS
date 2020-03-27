//
//  DatoComentario.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class DatoComentario:Codable {
    
    var id:Int!
    var tipo:Int!
    var post:Int!
    var cuerpo:String!
    
    init(id:Int, tipo:Int, post:Int, cuerpo:String) {
        
        self.id = id
        self.tipo = tipo
        self.post = post
        self.cuerpo = cuerpo
    }
}
