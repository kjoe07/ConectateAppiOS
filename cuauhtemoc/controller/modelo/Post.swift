//
//  Post.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/23/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class Post:Codable {
    
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
    
    
    
    init(id:Int, usuario:Usuario, titulo:String, keywords:[Keyword], promocionado:Bool, fecha:String, tipo:String, body:String, telefono:String, establecimiento:Establecimiento ) {
        
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

    }
    
    
}
