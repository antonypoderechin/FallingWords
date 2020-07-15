//
//  Word.swift
//  FallingWords
//
//  Created by Poderechin Anton on 15.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import Foundation

struct Word: Equatable {
    let eng: String
    let spa: String
}

extension Word: Decodable {
    private enum CodingKeys : String, CodingKey {
        case eng = "text_eng", spa = "text_spa"
    }
}
