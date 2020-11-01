//
//  Game.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import Foundation

enum GameErrors: Error {
    case CantFindRightAnswer
    case FinishTheGame
}

struct Game {
    
    private let questions: [Question]
    
    private var userAnswers = [Answer]()
    private(set) var score: Int = 0
    
    private var date: Date = Date()
    
    private var curentQuestionInd: Int = 0
    var question: Question {
        assert(isValid(curentQuestionInd), "Index out of range.")
        return questions[curentQuestionInd]
    }
        
    private func isValid(_ questionId: Int) -> Bool {
        return questionId >= 0 && questionId < questions.count
    }


    mutating func goToNextQuestion() throws {
        curentQuestionInd += 1
        
        if curentQuestionInd > questions.count - 1 {
            throw GameErrors.FinishTheGame
        }
    }
        
    mutating func addUserAnswer(answer: Answer) {
        switch answer {
        case .right:
            score += 10
        default:
            break
        }
                
        userAnswers.append(answer)
    }
    
    
    init(questions: [Question]) {
        self.questions = questions
    }
}

extension Game {
    static var empty: Game {
        return Game(questions: [])
    }
}

extension Game: Codable {
    
    private enum CodingKeys: CodingKey {
        case questions
        case userAnswers
        case score
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        questions = try container.decode([Question].self, forKey: .questions)
        print(questions)
        userAnswers = try container.decode([Answer].self, forKey: .userAnswers)
        print(userAnswers)
        score = try container.decode(Int.self, forKey: .score)
        print(score)
        date = try container.decode(Date.self, forKey: .date)
        print(date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(questions, forKey: .questions)
        try container.encode(userAnswers, forKey: .userAnswers)
        try container.encode(score, forKey: .score)
        try container.encode(date, forKey: .date)
    }
}


