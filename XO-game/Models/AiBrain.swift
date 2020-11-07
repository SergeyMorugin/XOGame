//
//  AiBrain.swift
//  XO-game
//
//  Created by Matthew on 06.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation


public class AiBrain {
    static public let shared = AiBrain()
    
    private init(){}
    
    func nextStep(gameboard: Gameboard) -> GameboardPosition? {
        for i in 0..<GameboardSize.columns{
            for j in 0..<GameboardSize.rows{
                let position = GameboardPosition(column: i, row: j)
                if gameboard.contains(at: position) == nil{
                    return position
                }
            }
        }
        return nil
    }
}
