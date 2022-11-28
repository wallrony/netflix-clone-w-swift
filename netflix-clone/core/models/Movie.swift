//
//  Movie.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

struct Movie: Decodable {
    var posterPath: String
    var adult: Bool
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var releaseDate: String
    var title: String
    var video: Bool
    var overview: String
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case title
        case video
        case overview
    }
}

struct MoviesPage: Decodable {
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
