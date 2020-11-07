//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet weak var gameTypeSelector: UISegmentedControl!
    private(set) lazy var referee = Referee(gameboard: self.gameboard)
    private(set) var gameType: GameType = .humanAgainstHuman
    
    public let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
        }
    }
    
    private func goToFirstState() {
        gameboard.clear()
        gameboardView.clear()
        self.gameType = GameType(rawValue: gameTypeSelector.selectedSegmentIndex) ?? .humanAgainstHuman
        self.currentState = GameStateFactory().build(gameType: self.gameType, context: self)
    }

    public func goToNextState(_ state: GameState) {
        self.currentState = state
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        self.goToFirstState()
        
    }
    
    @IBAction func onSegmentControlClick(_ sender: Any) {
        self.goToFirstState()
    }
}

