//
//  GameStateFactory.swift
//  XO-game
//
//  Created by Matthew on 06.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit


class GameStateFactory {
    func build(gameType: GameType, context: GameViewController) -> GameState{
        switch gameType {
        case .humanAgainstHuman:
            return PlayerInputState(player: .first, context: context)
        case .humanAgainstAi:
            return AIInputState(player: .first, context: context)
        case .humanAgainstHumanMode2:
            return PlayerInputStateMode2(player: .first, context: context, currentStep: 1)
        }
    }
}
 
