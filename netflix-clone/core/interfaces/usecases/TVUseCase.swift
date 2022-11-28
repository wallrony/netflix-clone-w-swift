//
//  MovieUseCase.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

protocol TrendingUseCase {
    var adapter: TrendingAdapter { get }
    
    init(adapter: TrendingAdapter);
    
    func fetchMovies() async throws -> [Movie]
    func fetchTvs() async throws -> [TV]
}
