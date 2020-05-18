//
//  Intereses.swift
//  cuauhtemoc
//
//  Created by Alejandro Figueroa on 9/16/19.
//  Copyright © 2019 Alejandro Figueroa. All rights reserved.
//

import Foundation


class Intereses:Codable {
    
    var id:Int!
    var tipo:Int!
    var tag:String!
    var imagen:String!
    
    init(id:Int, tipo:Int, tag:String, imagen:String) {
        
        self.id = id
        self.tipo = tipo
        self.tag = tag
        self.imagen = imagen
    }
    
}
struct HashtagProfileResponse : Codable {
    let count : Int?
    let next : String?
    let previous : String?
    let results : [Results]?

    enum CodingKeys: String, CodingKey {

        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        next = try values.decodeIfPresent(String.self, forKey: .next)
        previous = try values.decodeIfPresent(String.self, forKey: .previous)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
}
struct Results : Codable {
    let id : Int?
    let tipo : Int?
    let tag : String?
    let imagen : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case tipo = "tipo"
        case tag = "tag"
        case imagen = "imagen"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        tipo = try values.decodeIfPresent(Int.self, forKey: .tipo)
        tag = try values.decodeIfPresent(String.self, forKey: .tag)
        imagen = try values.decodeIfPresent(String.self, forKey: .imagen)
    }
}
