//
//  Caretaker.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import Foundation

class Caretaker {
   
    private let container = UserDefaults.standard
   
    private let gamesKey = "app.obryga.corp.WhoWhatnToBeAMilioner.games"
    private let lastGameKey = "app.obryga.corp.WhoWhatnToBeAMilioner.lastGame"
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private let maxSavedGamesCount = 20
    
    
    func saveGame(game: Game) {
        guard var games = container.array(forKey: gamesKey) else {
            return
        }
        
        if games.count == maxSavedGamesCount {
            games.remove(at: 0)
            games.append(game)
        } else {
            games.append(game)
        }
        
        container.set(games, forKey: gamesKey)
    }
    
    func getGames() -> [Game] {
        guard let games = container.array(forKey: gamesKey) as? [Game] else {
            return []
        }
        
        return games
    }
    
    func getLastGame() -> Game? {
        container.object(forKey: lastGameKey) as? Game
    }
}
