//
//  Accion.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/23/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


struct Accion:Codable {
    let id : Int?
    let tipo : Int?
    let post : Int?
    let cuerpo : String?
    let estatus : Int?
    let usuario : Usuario?
    let telefono_post : String?
    let nombre_post : String?
    let titulo_post : String?
    let fecha : String?
    let calificacion : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case tipo = "tipo"
        case post = "post"
        case cuerpo = "cuerpo"
        case estatus = "estatus"
        case usuario = "usuario"
        case telefono_post = "telefono_post"
        case nombre_post = "nombre_post"
        case titulo_post = "titulo_post"
        case fecha = "fecha"
        case calificacion = "calificacion"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        post = try values.decodeIfPresent(Int.self, forKey: .post)
        cuerpo = try values.decodeIfPresent(String.self, forKey: .cuerpo)
        estatus = try values.decodeIfPresent(Int.self, forKey: .estatus)
        usuario = try values.decodeIfPresent(Usuario.self, forKey: .usuario)
        telefono_post = try values.decodeIfPresent(String.self, forKey: .telefono_post)
        nombre_post = try values.decodeIfPresent(String.self, forKey: .nombre_post)
        titulo_post = try values.decodeIfPresent(String.self, forKey: .titulo_post)
        fecha = try values.decodeIfPresent(String.self, forKey: .fecha)
        calificacion = try values.decodeIfPresent(String.self, forKey: .calificacion)
    }
    
    
}

struct ActionResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Post]?
}

struct AddTruequeResponse : Codable {
    let id : Int?
    let tipo : Int?
    let post : Int?
    let cuerpo : String?
    let estatus : Int?
    let usuario : Usuario?
    let telefono_post : String?
    let nombre_post : String?
    let titulo_post : String?
    let fecha : String?
    let calificacion : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case tipo = "tipo"
        case post = "post"
        case cuerpo = "cuerpo"
        case estatus = "estatus"
        case usuario = "usuario"
        case telefono_post = "telefono_post"
        case nombre_post = "nombre_post"
        case titulo_post = "titulo_post"
        case fecha = "fecha"
        case calificacion = "calificacion"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        post = try values.decodeIfPresent(Int.self, forKey: .post)
        cuerpo = try values.decodeIfPresent(String.self, forKey: .cuerpo)
        estatus = try values.decodeIfPresent(Int.self, forKey: .estatus)
        usuario = try values.decodeIfPresent(Usuario.self, forKey: .usuario)
        telefono_post = try values.decodeIfPresent(String.self, forKey: .telefono_post)
        nombre_post = try values.decodeIfPresent(String.self, forKey: .nombre_post)
        titulo_post = try values.decodeIfPresent(String.self, forKey: .titulo_post)
        fecha = try values.decodeIfPresent(String.self, forKey: .fecha)
        calificacion = try values.decodeIfPresent(String.self, forKey: .calificacion)
    }
    
}
