//
//  GameEngine.swift
//  FallingWords
//
//  Created by Poderechin Anton on 16.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import Foundation
import UIKit

protocol GameEngineDelegate: AnyObject {
    func gameFinished()
}

/**
 Class encapsulates game logic. In update(timePassed:) receives time passed from last frame.
 GameEngine do not contain random word generator and game loop timer for better testability.
 */
class GameEngine {
    // MARK: - Properties
    weak var delegate: GameEngineDelegate?
    
    let wordFallTime = 3.0
    let wordsInRound = 5
    
    var words = [Word]()
    var currentWordModel: Word?
    var fallingWordModel: Word?
    var wordPosition: CGFloat = 0
    var wordsLeft = 0
    var correctCount = 0
    var wrongCount = 0
    
    // MARK: - Pubilc
    func start(words: [Word]) {
        self.words = words
        wordsLeft = wordsInRound
        correctCount = 0
        wrongCount = 0
        updateWords()
    }
    
    func update(timePassed: CFTimeInterval) {
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
            delegate?.gameFinished()
        }
    }
}
