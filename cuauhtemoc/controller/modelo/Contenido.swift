//
//  Contenido.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/21/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class Contenido:Codable {
    
    var id:Int!
    var usuario:Usuario!
    var titulo:String!
    var keywords:[Keyword]!
    var promocionado:Bool!
    var fecha:String!
    var tipo:String!
    var body:String!
    var telefono:String!
    var establecimiento:Establecimiento!
    
    var like:Int!
    var comments:Int!
    var trueques:Int!
    var contrataciones:Int!
    
    var img:String!
    var foto_perfil:String!
    
    init(id:Int, usuario:Usuario, titulo:String, keywords:[Keyword], promocionado:Bool, fecha:String, tipo:String, body:String, telefono:String, establecimiento:Establecimiento, like:Int, comments:Int, trueques:Int, contrataciones:Int, img:String, foto_perfil:String  ) {
        
        self.id = id
        self.usuario = usuario
        self.titulo = titulo
        self.keywords = keywords
        self.promocionado = promocionado
        self.fecha = fecha
        self.tipo = tipo
        self.body = body
        self.telefono = telefono
        self.establecimiento = establecimiento
        self.like = like
        self.comments = comments
        self.trueques = trueques
        self.contrataciones = contrataciones
        self.img = img
        self.foto_perfil = foto_perfil

    }


}
