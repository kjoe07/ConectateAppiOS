//
//  NotificacionCompleto.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


struct NotificacionCompleto:Codable {    
    let count:Int?
    let next:String?
    let previous:String?
    let results:[Notificacion]?
}
