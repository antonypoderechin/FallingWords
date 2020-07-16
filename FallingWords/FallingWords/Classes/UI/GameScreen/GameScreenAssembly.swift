//
//  GameScreenAssembly.swift
//  FallingWords
//
//  Created by Poderechin Anton on 15.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import UIKit

/**
 Class for manual DI. It create and connect all elements of the Game Screen.
 */
class GameScreenAssembly {
    static func create() -> UIViewController {
        let controller = GameScreenViewController()
        let viewModel = GameScreenViewModel()
        let engine = GameEngine()
        
        engine.wordPicker = GameWordPickerImpl()
        viewModel.gameEngine = engine
        viewModel.wordsService = WordsService()
        controller.viewModel = viewModel
        
        return controller
    }
}
