//
//  NotificacionCompleto.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/26/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class NotificacionCompleto:Codable {
    
    var count:Int!
    var next:String!
    var previous:String!
    var results:[Notificacion]!
    
    init(count:Int, next:String, previous:String, results:[Notificacion]) {
        
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
    
    
}
