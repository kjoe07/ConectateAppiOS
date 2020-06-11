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
    let recursos:[Recurso]?
    let acciones:[Accion]?
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
    var likes: Int?
    let comments: Int?
    let trueques: Int?
    let contrataciones: Int?
    let img: String?
    let foto_perfil: String?
    let distancia:String?
    var liked: Bool?
}
struct PostResponse: Codable{
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Post]?
    let error:String?
    
}
struct calificarResponse : Codable {
    let id : Int?
    let tipo : Int?
    let post : Int?
    let cuerpo : String?
    let estatus : Int?
    let calificacion : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case tipo = "tipo"
        case post = "post"
        case cuerpo = "cuerpo"
        case estatus = "estatus"
        case calificacion = "calificacion"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        post = try values.decodeIfPresent(Int.self, forKey: .post)
        cuerpo = try values.decodeIfPresent(String.self, forKey: .cuerpo)
        estatus = try values.decodeIfPresent(Int.self, forKey: .estatus)
        calificacion = try values.decodeIfPresent(Int.self, forKey: .calificacion)
    }

}
