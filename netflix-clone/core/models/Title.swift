//
//  Title.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

struct Title {
    var id: Int
    var name: String
    var posterPath: String
    var type: TitleType
    var overview: String
    var isAdult: Bool
    
    init(id: Int, name: String, posterPath: String, type: TitleType, overview: String, isAdult: Bool) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.type = type
        self.overview = overview
        self.isAdult = isAdult
    }
    
    static func Movie(_ movie: Movie) -> Title {
        return Title(
            id: movie.id,
            name: movie.title,
            posterPath: movie.posterPath,
            type: TitleType.Movie,
            overview: movie.overview,
            isAdult: movie.adult
        )
    }
    
    static func TV(_ tv: TV) -> Title {
        return Title(
            id: tv.id,
            name: tv.name,
            posterPath: tv.posterPath,
            type: TitleType.TV,
            overview: tv.overview,
            isAdult: tv.adult
        )
    }
}

struct TitleSection {
    var type: TitleType
    var name: String
    var classification: Int
    
    init(type: TitleType, name: String, classification: Int) {
        self.type = type
        self.name = name
        self.classification = classification
    }
    
    static func Movie(_ name: String, classification: MovieClassification) -> TitleSection {
        return TitleSection(type: TitleType.Movie, name: name, classification: classification.rawValue)
    }
    
    static func TV(_ name: String, classification: TVClassification) -> TitleSection {
        return TitleSection(type: TitleType.TV, name: name, classification: classification.rawValue)
    }
}

enum TitleType: Int {
    case Movie = 0
    case TV = 1
}

enum MovieClassification: Int {
    case Trending = 0
    case Popular = 1
    case Upcoming = 2
    case TopRated = 3
    case Discover = 4
}

enum TVClassification: Int {
    case Trending = 5
}

