//
//  Answer.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import Foundation

enum Answer {
    case right(String)
    case wrong(String)
    
    var answer: String {
        switch self {
        case .right(let answer):
            return answer
        case .wrong(let answer):
            return answer
        }
    }
}

extension Answer: Equatable {
    static func == (lhs: Self, rhs: String) -> Bool {
        lhs.answer == rhs
    }
}
