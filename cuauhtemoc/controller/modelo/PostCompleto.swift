//
//  PostCompleto.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/23/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class PostCompleto:Codable {
    
    var post:Post!
    var recursos:[Recurso]
    var acciones:[Accion]
    
    init(post:Post, recursos:[Recurso], acciones:[Accion]) {
        self.post = post
        self.recursos = recursos
        self.acciones = acciones
    }
    
    
}
