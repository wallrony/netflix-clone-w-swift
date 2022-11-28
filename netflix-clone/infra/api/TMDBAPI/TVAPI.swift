//
//  MoviesAPI.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

class TMDBAPI: BaseAPI, TrendingAdapter, UpcomingAdapter {
    static let shared = TMDBAPI()
    private let apiToken = ""
    
    required init() {
        super.init(baseURL: )
    }
    
    func fetchTrendingTvs() async throws -> [TV] {
        let data = try await self.fetchTrending(mediaType: "tv")
        let result = try JSONDecoder().decode(TVPage.self, from: data)
        return result.tvs
    }
    
    private func fetchTrending(mediaType: String) async throws -> Data {
        let request = self.prepareRequest(path: "/trending/\(mediaType)/week")
        let data = try await self.executeRequest(request: request)
        return data;
    }
}
