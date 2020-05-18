//
//  VerifyCodeResponse.swift
//  cuauhtemoc
//
//  Created by Yoel Jimenez del Valle on 4/27/20.
//  Copyright © 2020 Alejandro Figueroa. All rights reserved.
//

import Foundation
struct VerifyCodeResponse:Codable{
    let result : Int?
    let token : String?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Int.self, forKey: .result)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}
