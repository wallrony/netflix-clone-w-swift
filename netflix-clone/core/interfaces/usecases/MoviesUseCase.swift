//
//  UpcomingUseCase.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

protocol MoviesUseCase {
    var adapter: MoviesAdapter { get }
    
    init(adapter: MoviesAdapter)
    
    func fetchTrending() async throws -> [Movie]
    func fetchUpcoming() async throws -> [Movie]
    func fetchPopular() async throws -> [Movie]
    func fetchTopRated() async throws -> [Movie]
    func fetchDiscover() async throws -> [Movie]
    func fetchSearch(with query: String) async throws -> [Movie]
}
