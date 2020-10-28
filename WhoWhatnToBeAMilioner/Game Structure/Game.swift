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
    
    let questions: [Question]
    
    var userAnswers = [Answer]()
    var score: Int = 0
    
    private var curentQuestionInd: Int = 0
    var question: Question {
        assert(isValid(curentQuestionInd), "Index out of range.")
        return questions[curentQuestionInd]
    }

    mutating func goToNextQuestion() throws {
        curentQuestionInd += 1
        
        if curentQuestionInd > questions.count {
            throw GameErrors.FinishTheGame
        }
    }
        
    private func isValid(_ questionId: Int) -> Bool {
        return questionId > 0 && questionId < questions.count
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


