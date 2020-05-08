//
//  Perfil.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/25/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation

struct Perfil:Codable {
    
    let usuario:Usuario?
    let descripcion:[Intereses]?
    let intereses:[Intereses]?
    let extras:[Intereses]?
    let foto:String?
    
}
