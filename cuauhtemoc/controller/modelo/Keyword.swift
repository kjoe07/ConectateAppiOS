//
//  Keyword.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class Keyword:Codable {
    
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
