//
//  VerifyResponse.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/24/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import Foundation
struct RegisterResponse : Codable {
    let result : Int?
    let id : Int?
    let usuario : Usuario?
    let code : String?
    let error: String?
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case id = "id"
        case usuario = "usuario"
        case code = "code"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Int.self, forKey: .result)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        usuario = try values.decodeIfPresent(Usuario.self, forKey: .usuario)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        error = try? values.decodeIfPresent(String.self, forKey: .error)
    }
}
struct SendCodeResponse: Codable {
    let result : Int?
    let code : String?
    let error: String?
}
