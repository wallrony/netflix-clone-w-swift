//
//  MovieUseCase.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

protocol TVUseCase {
    var adapter: TVAdapter { get }
    
    init(adapter: TVAdapter);
    
    func fetchTrending() async throws -> [TV]
}
