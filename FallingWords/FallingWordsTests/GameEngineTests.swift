//
//  FallingWordsTests.swift
//  FallingWordsTests
//
//  Created by Poderechin Anton on 15.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import XCTest
@testable import FallingWords
import Combine

/**
 For game test used emulation of real update without actual waiting.
 */
class GameEngineTests: XCTestCase {
    
    /**
     Check that after word fallen it changed to another one.
     */
    func testWordChangedAfterFall() throws {
        // Given
        let engine = GameEngine()
        engine.wordPicker = GameWordPickerStub(
            currentWord: Word(eng: "word1", spa: "word1"),
            fallingWord: Word(eng: "word2", spa: "word2"))
        engine.start(words: [])
        let updatesPerSecond = 30.0
        let updatesCount = Int(engine.wordFallTime * updatesPerSecond) + 1
        let initialCurrentWord = engine.currentWordModel
        let initialFallingWord = engine.fallingWordModel
        
        // When
        engine.wordPicker = GameWordPickerStub(
            currentWord: Word(eng: "word3", spa: "word3"),
            fallingWord: Word(eng: "word4", spa: "word4"))
        for _ in 0...updatesCount {
            engine.update(timePassed: 1/updatesPerSecond)
        }
        
        // Then
        XCTAssert(initialCurrentWord != engine.currentWordModel)
        XCTAssert(initialFallingWord != engine.fallingWordModel)
    }
    
    /**
     Check that after all words fallen game state is  finished
     */
    func testFinishedAfterAllWords() throws {
        // Given
        let engine = GameEngine()
        engine.wordPicker = GameWordPickerImpl()
        let words = try wordsList()
        engine.start(words: words)
        let updatesPerSecond = 30.0
        let updatesCount = (Int(engine.wordFallTime * updatesPerSecond) + 1) * engine.wordsInRound
        
        // When
        for _ in 0...updatesCount {
            engine.update(timePassed: 1/updatesPerSecond)
        }
        
        // Then
        XCTAssert(engine.finished)
    }
    
    /**
     Test case when falling word and current word is the same word and correct button tapped.
     */
    func testSameWordCorrectTap() throws {
        // Given
        let engine = GameEngine()
        engine.wordPicker = GameWordPickerStub(
            currentWord: Word(eng: "word1", spa: "word1"),
            fallingWord: Word(eng: "word1", spa: "word1"))
        engine.start(words: [])
        engine.update(timePassed: 1/30.0)
        var onCorrectResult = 0
        // I think RX/Combine can replace mock's in some cases.
        var disposables = Set<AnyCancellable>()
        engine.$correctCount.sink {
            onCorrectResult = $0
        }.store(in: &disposables)
        
        // When
        engine.onCorrectTap()
        
        // Then
        XCTAssert(onCorrectResult > 0)
    }
    
    // MARK: - Helper
    func wordsList() throws -> [Word] {
        let pathString = Bundle(for: type(of: self)).path(forResource: "words", ofType: "json")
        let url = URL(fileURLWithPath: pathString!)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Word].self, from: data)
    }
}
