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
    @IBOutlet var leftCounterLabel: UILabel!
    @IBOutlet var topPannel: UIView!
    @IBOutlet var bottomPannel: UIView!
    @IBOutlet var flashView: UIView!
    
    private var scoreAlert: UIAlertController?
    private var errorAlert: UIAlertController?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.reload()
    }
    
    // MARK: - Private
    private func bind() {
        viewModel.$wordPosition.sink { [weak self] (position) in
            self?.updateFallingWord(position: position)
        }.store(in: &disposables)
        viewModel.$error.sink { [weak self] (error) in
            // Not shure that this is perfect way in MVVM to hide/show alerts
            self?.showError(error: error)
        }.store(in: &disposables)
        viewModel.$currentWord.sink { [weak self] (word) in
            self?.titleWordLabel.text = word
        }.store(in: &disposables)
        viewModel.$fallingWord.sink { [weak self] (word) in
            self?.fallingWordLabel.text = word
        }.store(in: &disposables)
        viewModel.$wordsLeft.sink { [weak self] (left) in
            self?.leftCounterLabel.text = left > 0 ? "\(left) left": "last word"
        }.store(in: &disposables)
        viewModel.$correctCount.removeDuplicates().sink { [weak self] count in
            // View should not flash when count is reseted to 0
            // Probably not very clean solution
            if count == 0 {
                return
            }
            self?.flashBackground(color: .green)
        }.store(in: &disposables)
        viewModel.$wrongCount.removeDuplicates().sink { [weak self] count in
            // View should not flash when count is reseted to 0
            // Probably not very clean solution
            if count == 0 {
                return
            }
            self?.flashBackground(color: .red)
        }.store(in: &disposables)
        viewModel.$showScore.sink { [weak self] show in
            self?.showScore(show: show)
        }.store(in: &disposables)
    }
    
    private func showScore(show: Bool) {
        if !show {
            scoreAlert?.dismiss(animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(
            title: "End!",
            message: "Your score is \(viewModel.correctCount)/\(viewModel.wordsInRound)",
            preferredStyle: .alert)
        let restart = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.viewModel.reload()
        }
        alert.addAction(restart)
        scoreAlert = alert
        present(alert, animated: true, completion: nil)
    }
    
    private func showError(error: Error?) {
        guard let error = error else {
            errorAlert?.dismiss(animated: true, completion: nil)
            return
        }
        let errorText = (error as NSError).localizedDescription
        let alert = UIAlertController(title: nil, message: errorText, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            self?.viewModel.closeErrorAlert()
        }
        alert.addAction(ok)
        errorAlert = alert
        present(alert, animated: true, completion: nil)
    }
    
    private func updateFallingWord(position: CGFloat) {
        let minY = topPannel.frame.maxY
        let fallingViewHeight = fallingView.frame.height
        let maxY = bottomPannel.frame.minY + fallingViewHeight
        let translation = (maxY - minY) * CGFloat(position)
        fallingView.transform = CGAffineTransform(translationX: 0, y: translation)
    }
    
    private func flashBackground(color: UIColor) {
        flashView.backgroundColor = color
        flashView.alpha = 0.5
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.flashView.alpha = 0
        }
    }
    
    // MARK: - IBAction
    @IBAction func onCorrectTap() {
        viewModel.onCorrectTap()
    }
    
    @IBAction func onWrongTap() {
        viewModel.onWrongTap()
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: "GameScreenViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
