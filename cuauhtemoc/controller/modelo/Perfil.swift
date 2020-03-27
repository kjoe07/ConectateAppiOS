//
//  Perfil.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

class Perfil:Codable {
    
    var usuario:Usuario!
    var descripcion:[Intereses]!
    var intereses:[Intereses]!
    var extras:[Intereses]!
    var foto:String!
    
    init(usuario:Usuario, descripcion:[Intereses], intereses:[Intereses], extras:[Intereses], foto:String) {
        
        self.usuario = usuario
        self.descripcion = descripcion
        self.intereses = intereses
        self.extras = extras
        self.foto = foto
    }
    
}
