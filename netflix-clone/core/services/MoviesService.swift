//
//  UpcomingService.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

class MoviesService: MoviesUseCase {
    internal let adapter: MoviesAdapter
    
    required init(adapter: MoviesAdapter) {
        self.adapter = adapter
    }
    
    func fetchTrending() async throws -> [Movie] {
        return try await self.adapter.fetchTrending()
    }
    
    func fetchUpcoming() async throws -> [Movie] {
        return try await self.adapter.fetchUpcoming()
    }
    
    func fetchPopular() async throws -> [Movie] {
        return try await self.adapter.fetchPopular()
    }
    
    func fetchTopRated() async throws -> [Movie] {
        return try await self.adapter.fetchTopRated()
    }
    
    func fetchDiscover() async throws -> [Movie] {
        return try await self.adapter.fetchDiscover()
    }
    
    func fetchSearch(with query: String) async throws -> [Movie] {
        return try await self.adapter.fetchSearch(with: query)
    }
}
