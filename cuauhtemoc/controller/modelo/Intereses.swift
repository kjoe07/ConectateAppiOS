//
//  Intereses.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/16/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class Intereses:Codable {
    
    var id:Int!
    var tipo:Int!
    var tag:String!
    var imagen:String!
    
    init(id:Int, tipo:Int, tag:String, imagen:String) {
        
        self.id = id
        self.tipo = tipo
        self.tag = tag
        self.imagen = imagen
    }
    
}
