//
//  Title.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

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
}

enum TVClassification: Int {
    case Trending = 4
}
