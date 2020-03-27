//
//  Recurso.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/23/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class Recurso:Codable {
    
    var id:Int!
    var orden:Int!
    var post:Int!
    var valor: String!
    var tipo:Int!
    
    init(id:Int, orden:Int, post:Int, valor:String, tipo:Int) {
        
        self.id = id
        self.orden = orden
        self.post = post
        self.valor = valor
        self.tipo = tipo
    }
    

}

