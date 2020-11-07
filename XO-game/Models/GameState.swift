//
//  GameState.swift
//  XO-game
//
//  Created by Matthew on 05.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

public protocol GameState {
    
    var isCompleted: Bool { get }
    
    func begin()
    
    func addMark(at position: GameboardPosition)
}




public class AIInputState: GameState {
    
    public private(set) var isCompleted = false
    
    public let player: Player
    private(set) weak var context: GameViewController!


    init(player: Player, context: GameViewController) {
        self.player = player
        self.context = context
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.context.firstPlayerTurnLabel.isHidden = false
            self.context.secondPlayerTurnLabel.isHidden = true
        case .ai:
            self.context.firstPlayerTurnLabel.isHidden = true
            self.context.secondPlayerTurnLabel.isHidden = false
            self.context.secondPlayerTurnLabel.text = "AI"
            
            aiMakeStep()
        default:
            print("Error")
        }
        
        self.context.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        guard
            let gameboardView = self.context.gameboardView,
            gameboardView.canPlaceMarkView(at: position),
            player == .first
        else { return }
        
        let markView: MarkView = XView()

        context.gameboard.setPlayer(self.player, at: position)
        gameboardView.placeMarkView(markView, at: position)
        self.isCompleted = true
        makeNextStepWithChecking()
    }
    
    private func aiMakeStep(){
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            guard
                let self = self,
                let context = self.context,
                let position = AiBrain.shared.nextStep(gameboard: context.gameboard)
            else {return}

            context.gameboard.setPlayer(.ai, at: position)
            let markView: MarkView = OView()
            context.gameboardView.placeMarkView(markView, at: position)
            self.isCompleted = true
            self.makeNextStepWithChecking()
        }
    }
    
    private func makeNextStepWithChecking(){
        let nextStepState = AIInputState(player: player.next(context.gameType), context: context)
        let state = CheckGameIsOverState(context: context, nextState: nextStepState)
        context.goToNextState(state)
    }
}

public class PlayerInputState: GameState {
    
    public private(set) var isCompleted = false
    
    public let player: Player
    private(set) weak var context: GameViewController!
    
    init(player: Player, context: GameViewController) {
        self.player = player
        self.context = context
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.context.firstPlayerTurnLabel.isHidden = false
            self.context.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.context.firstPlayerTurnLabel.isHidden = true
            self.context.secondPlayerTurnLabel.isHidden = false
        default:
            print("Error")
        }
        self.context.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        guard let gameboardView = context.gameboardView
            , gameboardView.canPlaceMarkView(at: position)
            else { return }
        
        let markView: MarkView
        switch self.player {
        case .first:
            markView = XView()
        case .second:
            markView = OView()
        default:
            print("Error")
            return
        }
        context.gameboard.setPlayer(self.player, at: position)
        context.gameboardView?.placeMarkView(markView, at: position)
        self.isCompleted = true
        makeNextStepWithChecking()
    }
    
    private func makeNextStepWithChecking(){
        let nextStepState = PlayerInputState(player: player.next(context.gameType), context: context)
        let state = CheckGameIsOverState(context: context, nextState: nextStepState)
        context.goToNextState(state)
    }
}

public class CheckGameIsOverState: GameState {
    public var isCompleted: Bool = false
    private var nextState: GameState
    private weak var context: GameViewController?
    
    
    init(context: GameViewController, nextState: GameState){
        self.nextState = nextState
        self.context = context
    }
    
    public func begin() {
        guard let context = self.context else {
            return
        }
        if let winner = context.referee.determineWinner() {
            context.goToNextState(GameEndedState(winner: winner, context: context))
            return
        }
        if context.gameboard.noMoreSteps(){
            context.goToNextState(GameEndedState(winner: nil, context: context))
            return
        }
        context.goToNextState(nextState)
    }
    
    public func addMark(at position: GameboardPosition) {}
}

public class GameEndedState: GameState {
    
    public let isCompleted = false
    
    public let winner: Player?
    private(set) weak var gameViewController: GameViewController?
    
    public init(winner: Player?, context: GameViewController) {
        self.winner = winner
        self.gameViewController = context
    }
    
    public func begin() {
        self.gameViewController?.winnerLabel.isHidden = false
        if let winner = winner {
            self.gameViewController?.winnerLabel.text = self.winnerName(from: winner) + " win"
        } else {
            self.gameViewController?.winnerLabel.text = "No winner"
        }
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) { }
    
    private func winnerName(from winner: Player) -> String {
        switch winner {
        case .first: return "1st player"
        case .second: return "2nd player"
        case .ai: return "Matrix has got you"
        }
    }
}


