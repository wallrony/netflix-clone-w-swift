//
//  Error.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

private protocol error: LocalizedError {
    var message: String { get }

    init(message: String)
}

struct Error: error {
    var message: String

    init(message: String) {
        self.message = message
    }
    
    static func failedToCacheData() -> Error {
        return Error(message: "An error occurred when trying to save data on cache")
    }
    
    static func failedToRestoreCachedData() -> Error {
        return Error(message: "An error occurred when trying to restore the cached data")
    }
    
    static func failedToDeleteCachedData() -> Error {
        return Error(message: "An error occurred when trying to remove a cached data")
    }

    static func unexpectedError() -> Error {
        return Error(message: "An unexpected error occurred. Please contact the support.")
    }
}
