//
//  GameScreenViewController.swift
//  FallingWords
//
//  Created by Poderechin Anton on 15.07.2020.
//  Copyright © 2020 Poderechin Anton. All rights reserved.
//

import UIKit
import Combine

class GameScreenViewController: UIViewController {
    // MARK: - Properties
    var viewModel: GameScreenViewModel!
    
    @IBOutlet var fallingView: UIView!
    @IBOutlet var titleWordLabel: UILabel!
    @IBOutlet var fallingWordLabel: UILabel!
    @IBOutlet var topPannel: UIView!
    @IBOutlet var bottomPannel: UIView!
    
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.restart()
    }
    
    // MARK: - Private
    private func bind() {
        viewModel.$wordPosition.sink { [weak self] (position) in
            self?.updateFallingWord(position: position)
        }.store(in: &disposables)
    }
    
    private func updateFallingWord(position: CGFloat) {
        let minY = topPannel.frame.maxY
        let fallingViewHeight = fallingView.frame.height
        let maxY = bottomPannel.frame.minY + fallingViewHeight
        let translation = (maxY - minY) * CGFloat(position)
        fallingView.transform = CGAffineTransform(translationX: 0, y: translation)
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: "GameScreenViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
