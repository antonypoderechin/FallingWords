//
//  WordsService.swift
//  FallingWords
//
//  Created by Poderechin Anton on 15.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import Foundation
import Combine

enum WordsServiceError: Error {
    case wrongPath
}

class WordsService {
    func words() -> AnyPublisher<[Word],Error> {
        let path = Bundle.main.path(forResource: "words", ofType: "json")
        return Just(path)
            .tryMap { (path) -> URL in
                if let path = path {
                    return URL(fileURLWithPath: path)
                } else {
                    throw WordsServiceError.wrongPath
                }
            }
            .tryMap{ try Data(contentsOf: $0) }
            .tryMap {
                try JSONDecoder().decode([Word].self, from: $0)
            }
            .eraseToAnyPublisher()
    }
}
