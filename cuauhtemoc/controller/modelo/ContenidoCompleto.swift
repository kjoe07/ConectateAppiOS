//
//  ContenidoCompleto.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/22/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class ContenidoCompleto:Codable {
    
    var count:Int!
    var next:String!
    var previous:String!
    var results:[Contenido]!
    
    init(count:Int, next:String, previous:String, results:[Contenido]) {
        
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }


}
