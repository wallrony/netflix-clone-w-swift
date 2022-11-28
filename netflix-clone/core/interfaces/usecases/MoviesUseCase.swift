//
//  UpcomingUseCase.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

protocol UpcomingUseCase {
    var adapter: UpcomingAdapter { get }
    
    init(adapter: UpcomingAdapter)
    
    func fetchMovies() async throws -> [Movie]
}
