//
//  MoviesAPI.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

class MoviesAPI: BaseTMDBAPI, MoviesAdapter {
    static let shared = MoviesAPI()
    
    func fetchTrending() async throws -> [Movie] {
        let request = self.prepareRequest(path: "/trending/movie/week")
        let data = try await self.executeRequest(request: request)
        let result = try JSONDecoder().decode(MoviesPage.self, from: data)
        return result.movies
    }
    
    func fetchUpcoming() async throws -> [Movie] {
        let request = self.prepareRequest(path: "/movie/upcoming")
        let data = try await self.executeRequest(request: request)
        let result = try JSONDecoder().decode(MoviesPage.self, from: data)
        return result.movies
    }
    
    func fetchPopular() async throws -> [Movie] {
        let request = self.prepareRequest(path: "/movie/popular")
        let data = try await self.executeRequest(request: request)
        let result = try JSONDecoder().decode(MoviesPage.self, from: data)
        return result.movies
    }
    
    func fetchTopRated() async throws -> [Movie] {
        let request = self.prepareRequest(path: "/movie/top_rated")
        let data = try await self.executeRequest(request: request)
        let result = try JSONDecoder().decode(MoviesPage.self, from: data)
        return result.movies
    }
    
    func fetchDiscover() async throws -> [Movie] {
        let request = self.prepareRequest(path: "/discover/movie", queryItems: [
            URLQueryItem(name: "include_video", value: "false")
        ])
        let data = try await self.executeRequest(request: request)
        let result = try JSONDecoder().decode(MoviesPage.self, from: data)
        return result.movies
    }
    
    func fetchSearch(with query: String) async throws -> [Movie] {
        let request = self.prepareRequest(path: "/search/movie", queryItems: [
            URLQueryItem(name: "query", value: query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        ])
        let data = try await self.executeRequest(request: request)
        let result = try JSONDecoder().decode(MoviesPage.self, from: data)
        return result.movies
    }
}
