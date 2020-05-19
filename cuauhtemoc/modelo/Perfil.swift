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
    let descripcion:[Results]?
    let intereses:[Results]?
    let extras:[Results]?
    let foto:String?
    
}
