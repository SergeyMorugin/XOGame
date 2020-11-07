//
//  Player.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation


public enum GameType: Int{
    case humanAgainstHuman = 0
    case humanAgainstAi = 1
    case humanAgainstHumanMode2 = 2
}

public enum Player:Int, CaseIterable {
    case first
    case second
    case ai
    
    func next(_ gameType: GameType)-> Player {
        switch gameType {
        case .humanAgainstAi:
            switch self {
              case .first: return .ai
              case .ai: return .first
              default: return .first
            }
        default:
            switch self {
             case .first: return .second
             case .second: return .first
             default: return .first
            }
        }
        
    }
}
