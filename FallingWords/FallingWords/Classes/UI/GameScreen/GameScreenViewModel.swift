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
 
 I've seen different versions of the MVVM some use ViewModel as simple entity and some stores here some screen related logic too.
 For this app I've chosen last approach to make code more easy readable.
 */
class GameScreenViewModel {
    // MARK: - Properties
    @Published var wordPosition: CGFloat = 0
    
    private var display: CADisplayLink?
    
    // MARK: - Public
    func restart() {
        display = CADisplayLink(target: self, selector: #selector(self.update))
        display?.add(to: .current, forMode: .default)
    }
    
    // MARK: - Private
    @objc private func update() {
        wordPosition = wordPosition + CGFloat((display?.duration ?? 0) / 10.0)
        if wordPosition > 1 {
            wordPosition = 0
        }
    }
}
