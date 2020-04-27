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
    var url:String{
        switch self {
        case .login:
            return "\(server.ws)/usuarios/login/"
        case .register:
            return "\(server.ws)/usuarios/registrar/"
        case .verifyCode:
            return "\(server.ws)/usuarios/verificarCodigo/"
        case .listProfileHashtags:
            return "\(server.ws)/clasificador/listHastTagPerfil/?page_size=300"
        case .description:
            return "\(server.ws)/usuarios/unaDescripcion"
        case .listInterestHashtags:
            return "\(server.ws)/clasificador/listHastTagIntereses/?page_size=300"
        case .addInterest:
            return "\(server.ws)/usuarios/unInteres/"
        case .addExtra:
            return "\(server.ws)/usuarios/agregarExtra/"
        case .addComment:
            return "\(server.ws)/contenido/list_post/?page_size=300"
        case .listContent:
             return "\(server.ws)/contenido/list_post/?page_size=300"
        case .singleContent:
            return "\(server.ws)/contenido/ver_post/"
        case .createContent:
            return "\(server.ws)/contenido/add_post/"
        case .listHashTagsByKeyword:
            return "\(server.ws)/clasificador/listHastTagKetwords/?page_size=300"
        case .seeProfile:
            return "\(server.ws)/usuarios/verPerfil/"
        case .notification:
            return "\(server.ws)/usuarios/notificaciones/?page_size=30"
        case .updateUser:
            return "\(server.ws)/usuarios/update_usuario/"
        case .sendCode:
            return "\(server.ws)/usuarios/verificarCodigo/"
        
        case .contentAction:
            return  "\(server.ws)/contenido/acciones/add"
        }
    }
    
    
}
