//
//  BaseAPI.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

class BaseTMDBAPI: BaseAPI {
    private let apiKey = "71e0d98e22eda7a1e03cb4a913db3769"
    
    init() {
        super.init(baseURL: "https://api.themoviedb.org/3/")
    }
    
    override internal func prepareRequest(path: String, queryItems: [URLQueryItem] = []) -> URLRequest {
        return super.prepareRequest(path: path, queryItems: [
            URLQueryItem(name: "api_key", value: self.apiKey)
        ] + queryItems)
    }
}
