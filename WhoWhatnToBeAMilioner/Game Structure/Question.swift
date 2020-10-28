//
//  Question.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import Foundation

struct Question: Codable {
    let question: String
    let answers: [Answer]
    
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
}
