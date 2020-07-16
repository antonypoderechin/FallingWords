//
//  GameWordPicker.swift
//  FallingWords
//
//  Created by Poderechin Anton on 16.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import Foundation

/**
 Protocol used in GameEngine tests.
 */
protocol GameWordPicker {
    /**
     Returns word to guess
     */
    func currentWord(words: [Word]) -> Word?
    /**
     Returns falling word. May return current word.
     */
    func fallingWord(currentWord: Word?, words: [Word]) -> Word?
}

class GameWordPickerImpl: GameWordPicker {
    func currentWord(words: [Word]) -> Word? {
        return words.randomElement()
    }

    func fallingWord(currentWord: Word?, words: [Word]) -> Word? {
        return Bool.random() ? currentWord: words.randomElement()
    }
}
