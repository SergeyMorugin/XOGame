//
//  Command.swift
//  XO-game
//
//  Created by Matthew on 07.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

protocol Command {
    func execute()
}

class AddMarkCommand: Command{
    private let player: Player
    private let position: GameboardPosition
    private let context: GameViewController
    private let delay: Int
    
    func execute() {
        
        context.gameboard.setPlayer(self.player, at: position)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)){
            let markView = MarkViewBuilder().build(player: self.player)
            if !(self.context.gameboardView?.canPlaceMarkView(at: self.position) ?? false){
                self.context.gameboardView?.removeMarkView(at: self.position)
            }
            self.context.gameboardView?.placeMarkView(markView, at: self.position)
        }
    }
    
    init(player: Player, position: GameboardPosition, context: GameViewController, delaySec: Int = 0){
        self.player = player
        self.position = position
        self.context = context
        self.delay = delaySec
    }
}

final class Invoker {
    static let shared = Invoker()
    private var firstPlayerCommands: [Command] = []
    private var secondPlayerCommands: [Command] = []
    
    public func addCommand(player: Player, command: Command){
        switch player {
        case .first:
            firstPlayerCommands.append(command)
        default:
            secondPlayerCommands.append(command)
        }
    }
    
    public func executeGame(){
        let size = firstPlayerCommands.count
        
        for i in 0..<size{
            self.firstPlayerCommands[i].execute()
            self.secondPlayerCommands[i].execute()
        }
        
    }
    
    private init(){
        
    }
}


