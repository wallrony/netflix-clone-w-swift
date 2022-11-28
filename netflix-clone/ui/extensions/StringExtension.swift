//
//  StringExtension.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

extension String {
    func captalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
