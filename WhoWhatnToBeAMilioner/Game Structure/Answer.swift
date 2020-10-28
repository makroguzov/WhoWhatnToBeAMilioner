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

extension Answer: Codable {
    private enum CodingKeys: CodingKey {
        case type
        case answer
    }
    
    private enum AnswerType: String {
        case right, wrong
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let type = try? AnswerType.init(rawValue: container.decode(String.self, forKey: .type)) else {
            throw DecodingError.keyNotFound(CodingKeys.type,
                                            DecodingError.Context(codingPath: [CodingKeys.type],
                                                                  debugDescription: "Decode error."
                                            ))
        }
        let answer = try container.decode(String.self, forKey: .answer)
        
        switch type {
        case .right:
            self = .right(answer)
        case .wrong:
            self = .wrong(answer)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .right:
            try container.encode(AnswerType.right.rawValue, forKey: .type)
        case .wrong:
            try container.encode(AnswerType.wrong.rawValue, forKey: .type)
        }

        try container.encode(answer, forKey: .answer)
    }
}
