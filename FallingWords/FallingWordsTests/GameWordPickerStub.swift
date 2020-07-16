//
//  GameWordPickerStub.swift
//  FallingWordsTests
//
//  Created by Poderechin Anton on 16.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

@testable import FallingWords

class GameWordPickerStub: GameWordPicker {
    // MARK: - Public
    let currentWord: Word
    let fallingWord: Word
    
    init(currentWord: Word, fallingWord: Word) {
        self.currentWord = currentWord
        self.fallingWord = fallingWord
    }
    
    // MARK: - GameWordPicker
    func currentWord(words: [Word]) -> Word? {
        return currentWord
    }
    
    func fallingWord(currentWord: Word?, words: [Word]) -> Word? {
        return fallingWord
    }
}

