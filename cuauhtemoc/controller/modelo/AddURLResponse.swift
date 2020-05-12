//
//  AddURLResponse.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 5/12/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import Foundation
struct AddURlResponse: Codable {
    let id : Int?
    let orden : Int?
    let post : Int?
    let valor : String?
    let tipo : Int?
    let latitud : Double?
    let longitud : Double?
    let nombre : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case orden = "orden"
        case post = "post"
        case valor = "valor"
        case latitud = "latitud"
        case longitud = "longitud"
        case tipo = "tipo"
        case nombre = "nombre"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        orden = try values.decodeIfPresent(Int.self, forKey: .orden)
        post = try values.decodeIfPresent(Int.self, forKey: .post)
        valor = try values.decodeIfPresent(String.self, forKey: .valor)
        latitud = try? values.decodeIfPresent(Double.self, forKey: .latitud)
        longitud = try? values.decodeIfPresent(Double.self, forKey: .longitud)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        nombre = try? values.decodeIfPresent(String.self, forKey: .nombre)
    }
}
struct AddPostResponse : Codable {
    let id : Int?
    let titulo : String?
    let tipo : Int?
    let body : String?
    let establecimiento : String?
    let telefono : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case titulo = "titulo"
        case tipo = "tipo"
        case body = "body"
        case establecimiento = "establecimiento"
        case telefono = "telefono"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        titulo = try values.decodeIfPresent(String.self, forKey: .titulo)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        establecimiento = try values.decodeIfPresent(String.self, forKey: .establecimiento)
        telefono = try values.decodeIfPresent(String.self, forKey: .telefono)
    }

}
