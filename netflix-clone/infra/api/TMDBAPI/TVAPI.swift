//
//  MoviesAPI.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

class TVAPI: BaseTMDBAPI, TVAdapter {
    static let shared = TVAPI()
    
    func fetchTrending() async throws -> [TV] {
        let request = self.prepareRequest(path: "/trending/tv/week")
        let data = try await self.executeRequest(request: request)
        let result = try JSONDecoder().decode(TVPage.self, from: data)
        return result.tvs
    }
}
