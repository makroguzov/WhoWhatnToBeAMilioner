//
//  NetworkServise.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import Foundation

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
            URLQueryItem(name: "count", value: "15")
        ]
        
        return uc
    }()    
    
    func getQuestions() {
        guard let url = urlConstructor.url else {
            print("url")
            return
        }
        
        session.dataTask(with: url) { (data , response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                print("aw;eof")
                return
            }
            
            print(json)
        }.resume()
    }
    
}
