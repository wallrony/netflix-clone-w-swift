//
//  MoviesAdapter.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

protocol TVAdapter {
    func fetchTrending() async throws -> [TV]
}
