//
//  GameEngine.swift
//  FallingWords
//
//  Created by Poderechin Anton on 16.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import Foundation
import UIKit

/**
 Class encapsulates game logic. In update(timePassed:) receives time passed from last frame.
 GameEngine do not contain random word generator and game loop timer for better testability.
 */
class GameEngine {
    // MARK: - Properties
    let wordFallTime = 3.0
    let wordsInRound = 5
    
    @Published var currentWordModel: Word?
    @Published var fallingWordModel: Word?
    @Published var wordPosition: CGFloat = 0
    @Published var wordsLeft = 0
    @Published var correctCount = 0
    @Published var wrongCount = 0
    @Published var finished = false
    
    private var words = [Word]()
    
    // MARK: - Pubilc
    func start(words: [Word]) {
        self.words = words
        wordsLeft = wordsInRound
        correctCount = 0
        wrongCount = 0
        finished = false
        updateWords()
    }
    
    func update(timePassed: CFTimeInterval) {
        if finished {
            return
        }
        wordPosition = wordPosition + CGFloat(timePassed / wordFallTime)
        if wordPosition > 1 {
            updateWords()
        }
    }
    
    func onCorrectTap() {
        if currentWordModel == fallingWordModel {
            correctCount += 1
        } else {
            wrongCount += 1
        }
        updateWords()
    }
    
    func onWrongTap() {
        if currentWordModel != fallingWordModel {
            correctCount += 1
        } else {
            wrongCount += 1
        }
        updateWords()
    }
    
    // MARK: - Private
    private func updateWords() {
        currentWordModel = words.randomElement()
        fallingWordModel = Bool.random() ? currentWordModel: words.randomElement()
        wordsLeft = wordsLeft - 1
        wordPosition = 0
        if wordsLeft < 0 {
            finished = true
        }
    }
}
