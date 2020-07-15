//
//  GameScreenViewModel.swift
//  FallingWords
//
//  Created by Poderechin Anton on 15.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import Combine
import UIKit

/**
 This class provides state for View and handlles communications with model layer objects.
 
 I've seen different versions of the MVVM some use ViewModel as simple entity and some stores here some screen related logic.
 For this app I've chosen last approach to make code more easy to read.
 */
class GameScreenViewModel {
    // MARK: - Properties
    @Published var wordPosition: CGFloat = 0
    @Published var currentWord: String = ""
    @Published var fallingWord: String = ""
    @Published var error: Error?
    @Published var wordsLeft = 0
    @Published var correctCount = 0
    @Published var wrongCount = 0
    @Published var showScore = false
    
    let wordsInRound = 5
    var wordsService: WordsService!
    
    private let wordFallTime = 3.0
    private var words = [Word]()
    private var currentWordModel: Word?
    private var fallingWordModel: Word?
    
    private var display: CADisplayLink?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Public
    func restart() {
        wordsService.words().sink(
            receiveCompletion: { [weak self] status in
                switch status {
                case .failure(let error):
                    self?.error = error
                case .finished:
                  break
                }
            },
            receiveValue: { [weak self] words in
                self?.start(words: words)
            })
            .store(in: &disposables)
    }
    
    func closeErrorAlert() {
        error = nil
        restart()
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
    private func start(words: [Word]) {
        self.words = words
        if display != nil {
            display?.invalidate()
        }
        display = CADisplayLink(target: self, selector: #selector(self.update))
        display?.add(to: .current, forMode: .default)
        wordsLeft = wordsInRound
        correctCount = 0
        wrongCount = 0
        showScore = false
        
        updateWords()
    }
    
    private func updateWords() {
        currentWordModel = words.randomElement()
        fallingWordModel = Bool.random() ? currentWordModel: words.randomElement()
        currentWord = currentWordModel!.eng
        fallingWord = fallingWordModel!.spa
        wordsLeft = wordsLeft - 1
        wordPosition = 0
        if wordsLeft < 0 {
            end()
        }
    }
    
    private func end() {
        display?.invalidate()
        showScore = true
    }
    
    @objc private func update() {
        wordPosition = wordPosition + CGFloat((display?.duration ?? 0) / wordFallTime)
        if wordPosition > 1 {
            updateWords()
        }
    }
}
