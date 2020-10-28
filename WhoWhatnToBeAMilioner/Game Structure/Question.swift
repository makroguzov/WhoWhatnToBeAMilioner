//
//  Question.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import Foundation

struct Question: Codable {
    var question: String = ""
    var answers: [Answer] = []
    
    func getRightAnswer() throws -> Answer {
        for answer in answers {
            switch answer {
            case .right:
                return answer
            default:
                continue
            }
        }
        
        throw GameErrors.CantFindRightAnswer
    }
    
    init(json: JSON) {
        guard let question = json["question"] as? String,
              var answers = json["answers"] as? [String] else {
            return
        }
        
        self.question = question
        
        self.answers.append(.right(answers.first ?? ""))
        answers.remove(at: 0)
        
        answers.forEach({ self.answers.append(.wrong($0)) })
    }
}

