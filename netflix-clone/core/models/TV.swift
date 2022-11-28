//
//  TV.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

struct TV: Decodable {
    var adult: Bool
    var id: Int
    var name: String
    var originalLanguage: String
    var originalName: String
    var overview: String
    var posterPath: String
    var firstAirDate: String
    
    enum CodingKeys: String, CodingKey {
        case adult
        case id
        case name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
    }
}

struct TVPage: Decodable {
    var page: Int
    var tvs: [TV]
    
    enum CodingKeys: String, CodingKey {
        case page
        case tvs = "results"
    }
}
