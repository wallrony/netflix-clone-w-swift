//
//  MoviesAdapter.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

protocol TrendingAdapter {
    
    func fetchTrendingTvs() async throws -> [TV]
}
