//
//  NetworkServise.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import Foundation

typealias JSON = [String: Any]

class NetworkServise {
 
    
    static let defolt = NetworkServise()
    private init(){}
    
    private let session = URLSession(configuration: .default)
    private lazy var urlConstructor: URLComponents = {
        var uc = URLComponents()
        
        uc.scheme = "https"
        uc.host = "engine.lifeis.porn"
        uc.path = "/api/millionaire.php"
        
        uc.queryItems = [
            URLQueryItem(name: "qType", value: "2"),
            URLQueryItem(name: "count", value: "5")
        ]
        
        return uc
    }()    
    
    func getQuestions(complition: @escaping (_ game: Game) -> Void) {
        guard let url = urlConstructor.url else {
            return
        }
        
        session.dataTask(with: url) { (data , response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                  let questionsJSON = (json as? JSON)?["data"] as? [JSON]  else {
                return
            }
            
            let questions = questionsJSON.map({ Question(json: $0) })
            complition(Game(questions: questions))
        }.resume()
    }
    
}
