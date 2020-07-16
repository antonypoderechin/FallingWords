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
    
    var wordsInRound = 5
    var wordsService: WordsService!
    var gameEngine: GameEngine! {
        didSet {
            gameBindings()
        }
    }
    
    private var display: CADisplayLink?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Public
    func reload() {
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
        reload()
    }
    
    func onCorrectTap() {
        gameEngine.onCorrectTap()
    }
    
    func onWrongTap() {
        gameEngine.onWrongTap()
    }
    
    // MARK: - Private
    private func gameBindings() {
        gameEngine.$wordPosition.assign(to: \.wordPosition, on: self).store(in: &disposables)
        gameEngine.$wordsLeft.assign(to: \.wordsLeft, on: self).store(in: &disposables)
        gameEngine.$correctCount.assign(to: \.correctCount, on: self).store(in: &disposables)
        gameEngine.$wrongCount.assign(to: \.wrongCount, on: self).store(in: &disposables)
        gameEngine.$currentWordModel.compactMap { $0?.eng }.assign(to: \.currentWord, on: self).store(in: &disposables)
        gameEngine.$fallingWordModel.compactMap { $0?.spa }.assign(to: \.fallingWord, on: self).store(in: &disposables)
        gameEngine.$finished.sink { [weak self] (finished) in
            if finished {
                self?.gameFinished()
            }
        }.store(in: &disposables)
    }
    
    private func start(words: [Word]) {
        display = CADisplayLink(target: self, selector: #selector(self.update))
        display?.add(to: .main, forMode: .default)
        showScore = false
        gameEngine.start(words: words)
        wordsInRound = gameEngine.wordsInRound
    }
    
    private func gameFinished() {
        display?.invalidate()
        showScore = true
    }
    
    @objc private func update() {
        gameEngine.update(timePassed: display?.duration ?? 0)
    }
}
