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
        var games: [Game] = container.array(forKey: gamesKey) as? [Game] ?? []
        
        if games.count == maxSavedGamesCount {
            games.remove(at: 0)
            games.append(game)
        } else {
            games.append(game)
        }
        
        do {
            let data = try encoder.encode(games)
            container.set(data, forKey: gamesKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getGames() -> [Game] {
        do {
            guard let data = container.data(forKey: gamesKey) else {
                print("werwr")
                return []
            }
            
            let games = try decoder.decode([Game].self, from: data)
            return games
        } catch let DecodingError.dataCorrupted(context){
            print("\(context.debugDescription) with keys: \(context.codingPath)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("\(context.debugDescription) with key: \(key)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("\(context.debugDescription) with key: \(type). Keys: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(type, context) {
            print("\(context.debugDescription) with key: \(type)")
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func getLastGame() -> Game? {
        container.object(forKey: lastGameKey) as? Game
        
    }
}
