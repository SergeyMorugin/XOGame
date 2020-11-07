//
//  PlayerInputStateMode2.swift
//  XO-game
//
//  Created by Matthew on 07.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class PlayerInputStateMode2: GameState {
    
    public let MAX_STEPS = 5
    
    public private(set) var isCompleted = false
    
    public let player: Player
    public let currentStep: Int
    private(set) weak var context: GameViewController!
    
    init(player: Player, context: GameViewController, currentStep: Int) {
        self.player = player
        self.context = context
        self.currentStep = currentStep
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
        
        let markView = MarkViewBuilder().build(player: player)
        context.gameboard.setPlayer(self.player, at: position)
        context.gameboardView?.placeMarkView(markView, at: position)
        
        let delay = player.rawValue + currentStep * 2
        let command = AddMarkCommand(player: player, position: position, context: context, delaySec: delay)
        Invoker.shared.addCommand(player: player, command: command)
        
        
        if isLastMark(){
            
            context.gameboardView.clear()
            Invoker.shared.executeGame()
            let state = CheckGameIsOverState(context: context, nextState: GameEndedState(winner: nil, context: context))
            context.goToNextState(state)
            return
        }
        
        self.isCompleted = true
        var nextStep =  1
        var nextPlayer = self.player
        if (currentStep < MAX_STEPS) {
            nextStep =  currentStep + 1
        } else {
            nextPlayer =  self.player.next(context.gameType)
            context.gameboardView.clear()
        }

        
        let nextStepState = PlayerInputStateMode2(player: nextPlayer, context: context, currentStep: nextStep)
        context.goToNextState(nextStepState)
        
    }
    
    private func isLastMark()->Bool{
        return currentStep == MAX_STEPS && player == .second
    }
}
