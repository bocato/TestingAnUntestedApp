//
//  NetworkModels.swift
//  SimpleMovies
//
//  Created by Eduardo Sanches Bocato on 17/02/20.
//  Copyright © 2020 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case api(OMDBError)
    case raw(Error)
    case unexpected
    case unknown
}

struct OMDBError: Codable {
    let response: String
    let error: String
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
    
    static let unknown = OMDBError(response: "False", error: "Unknown error.")
}
