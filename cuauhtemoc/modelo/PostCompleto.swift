//
//  PostCompleto.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/23/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class PostCompleto:Codable {
    
    let post:Post?
    let recursos:[Recurso]
    let acciones:[Accion]
    
    init(post:Post, recursos:[Recurso], acciones:[Accion]) {
        self.post = post
        self.recursos = recursos
        self.acciones = acciones
    }
    
    
}
struct Post: Codable {
    let id:Int?
    let usuario:Usuario?
    let titulo:String?
    let keywords:[Keyword]?
    let promocionado:Bool?
    let fecha:String?
    let tipo:String?
    let body:String?
    let telefono:String?
    let establecimiento:Establecimiento?
    let likes: Int?
    let comments: Int?
    let trueques: Int?
    let contrataciones: Int?
    let img: String?
    let foto_perfil: String?
}
struct PostResponse: Codable{
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Post]?
    let error:String?
    
}
