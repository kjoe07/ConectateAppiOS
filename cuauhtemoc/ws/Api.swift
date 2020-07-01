//
//  Api.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/16/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import Foundation
//var ws = ""
//#if DEBUG
//ws = "http://conectateyempleate.com"
//#else
//ws = "http://conectateyempleate.com"
//let ws = "http://conectateyempleate.com"

struct server {
    #if DEBUG
    static let ws = "http://test.conectateyempleate.com"
    #else
    static let ws = "http://conectateyempleate.com"
    #endif
}
enum Api {
    case login
    case register
    case sendCode
    case verifyCode
    case listProfileHashtags
    case description
    case listInterestHashtags
    case addInterest
    case addExtra
    case addComment
    case listContent
    case singleContent
    case createContent
    case listHashTagsByKeyword
    case seeProfile
    case notification
    case updateUser
    case contentAction
    case addKeywordPost
    case updatePassword
    case addFile
    case recoverPassword
    case calificar
    case updatePost(id: Int)
    var url:String{
        switch self {
        case .login:
            return "\(server.ws)/usuarios/login/"
        case .register:
            return "\(server.ws)/usuarios/registrar/"
        case .verifyCode:
            return "\(server.ws)/usuarios/verificarCodigo/"
        case .listProfileHashtags:
            return "\(server.ws)/clasificador/listHastTagPerfil/"
        case .description:
            return "\(server.ws)/usuarios/agregarDescripcion/"
        case .listInterestHashtags:
            return "\(server.ws)/clasificador/listHastTagIntereses/"
        case .addInterest:
            return "\(server.ws)/usuarios/agregarIntereses/"
        case .addExtra:
            return "\(server.ws)/usuarios/agregarExtra/"
        case .addComment:
            return "\(server.ws)/contenido/list_post/"
        case .listContent:
             return "\(server.ws)/contenido/list_post/"
        case .singleContent:
            return "\(server.ws)/contenido/ver_post/"
        case .createContent:
            return "\(server.ws)/contenido/add_post/"
        case .listHashTagsByKeyword:
            return "\(server.ws)/clasificador/listHastTagKetwords/"
        case .seeProfile:
            return "\(server.ws)/usuarios/verPerfil/"
        case .notification:
            return "\(server.ws)/usuarios/notificaciones/"
        case .updateUser:
            return "\(server.ws)/usuarios/update_usuario/"
        case .sendCode:
            return "\(server.ws)/usuarios/enviarCodigo/"
        case .contentAction:
            return  "\(server.ws)/contenido/acciones/add"
        case .addKeywordPost:
            return "\(server.ws)/contenido/add_keyword_post/"
        case .updatePassword:
            return "\(server.ws)/usuarios/cambiar_password/"
        case .addFile:
            return "\(server.ws)/contenido/add_archivo/"
        case .recoverPassword:
            return "\(server.ws)/usuarios/resetPassword/"
        case .calificar:
            return "\(server.ws)/contenido/acciones/update/"
        case .updatePost(let id):
            return "\(server.ws)/contenido/update_post/\(id)/"
        }
    }
}
