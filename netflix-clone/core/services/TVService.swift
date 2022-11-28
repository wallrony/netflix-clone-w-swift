//
//  MovieService.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

class TVSevice: TVUseCase {
    internal var adapter: TVAdapter
    
    required init(adapter: TVAdapter) {
        self.adapter = adapter
    }
    
    func fetchTrending() async throws -> [TV] {
        return try await self.adapter.fetchTrending()
    }
}
