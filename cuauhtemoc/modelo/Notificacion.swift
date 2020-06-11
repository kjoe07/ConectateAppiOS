//
//  Notificacion.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

struct Notificacion :Codable {
    let id : Int?
    let usuario : Usuario_envio?
    let usuario_envio : Usuario_envio?
    let interfaz : Int?
    let tipo : Int?
    let cuerpo : String?
    let estatus : Bool?
    let fecha : String?
    let content_object : Content_object?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case usuario = "usuario"
        case usuario_envio = "usuario_envio"
        case interfaz = "interfaz"
        case tipo = "tipo"
        case cuerpo = "cuerpo"
        case estatus = "estatus"
        case fecha = "fecha"
        case content_object = "content_object"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        usuario = try values.decodeIfPresent(Usuario_envio.self, forKey: .usuario)
        usuario_envio = try values.decodeIfPresent(Usuario_envio.self, forKey: .usuario_envio)
        interfaz = try values.decodeIfPresent(Int.self, forKey: .interfaz)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        cuerpo = try values.decodeIfPresent(String.self, forKey: .cuerpo)
        estatus = try values.decodeIfPresent(Bool.self, forKey: .estatus)
        fecha = try values.decodeIfPresent(String.self, forKey: .fecha)
        content_object = try values.decodeIfPresent(Content_object.self, forKey: .content_object)
    }
}
struct Usuario_envio : Codable {
    let id : Int?
    let nombre : String?
    let apellido : String?
    let celular : String?
    let fecha_nacimiento : String?
    let cp : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case nombre = "nombre"
        case apellido = "apellido"
        case celular = "celular"
        case fecha_nacimiento = "fecha_nacimiento"
        case cp = "cp"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        nombre = try values.decodeIfPresent(String.self, forKey: .nombre)
        apellido = try values.decodeIfPresent(String.self, forKey: .apellido)
        celular = try values.decodeIfPresent(String.self, forKey: .celular)
        fecha_nacimiento = try values.decodeIfPresent(String.self, forKey: .fecha_nacimiento)
        cp = try values.decodeIfPresent(String.self, forKey: .cp)
    }

}
struct Content_object : Codable {
    let id : Int?
    let titulo : String?
    let tipo : Int?
    let body : String?
    let establecimiento : String?
    let telefono : String?
    let post: Int?
    let cuerpo: String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case titulo = "titulo"
        case tipo = "tipo"
        case body = "body"
        case establecimiento = "establecimiento"
        case telefono = "telefono"
        case post = "post"
        case cuerpo = "cuerpo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        titulo = try values.decodeIfPresent(String.self, forKey: .titulo)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        body = try? values.decodeIfPresent(String.self, forKey: .body)
        establecimiento = try? values.decodeIfPresent(String.self, forKey: .establecimiento)
        telefono = try? values.decodeIfPresent(String.self, forKey: .telefono)
        post = try? values.decodeIfPresent(Int.self, forKey: .post)
        cuerpo = try? values.decodeIfPresent(String.self, forKey: .cuerpo)
    }

}
