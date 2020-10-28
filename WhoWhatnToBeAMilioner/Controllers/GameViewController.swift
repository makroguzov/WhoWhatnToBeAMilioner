//
//  GameViewController.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet private weak var questionLable: UILabel! {
        didSet {
            setUp(questionLable)
        }
    }
    
    @IBOutlet private weak var answer1Lable: UILabel! {
        didSet {
            setUp(answer1Lable)
        }
    }
    @IBOutlet private weak var answer2Lable: UILabel! {
        didSet {
            setUp(answer2Lable)
        }
    }
    @IBOutlet private weak var answer3Lable: UILabel! {
        didSet {
            setUp(answer3Lable)
        }
    }
    @IBOutlet private weak var answer4Lable: UILabel! {
        didSet {
            setUp(answer4Lable)
        }
    }
    
    
    var game: Game = .empty
    
    private var player = AVAudioPlayer() {
        didSet {
            player.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setUp(_ lable: UILabel) {
        lable.layer.cornerRadius = 10
        lable.layer.borderWidth = 4
        lable.layer.borderColor = UIColor.blue.cgColor
        
        lable.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLableAction(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        lable.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapLableAction(_ sender: UILabel) {
        let question = game.question
        let userAnswer = sender.text ?? ""
        
        guard let answer = question.answers.filter({ $0 == userAnswer }).first else {
            return
        }
        
        switch answer {
        case .right:
            setUpWithRighrAnswer(sender)
        case .wrong:
            do {
                let rightAnswer = try question.getRightAnswer()
                setUpWithWrongAnswer(sender, rightAnswer: rightAnswer)
            } catch GameErrors.CantFindRightAnswer {
                let alert = UIAlertController(title: "Error",
                                              message: "Something wrong with answer",
                                              preferredStyle: .alert
                )
                alert.present(self, animated: true)
            } catch {
                print("Unknown error.")
            }
        }
        
        save(answer: answer)
    }
    
    private func setUpWithRighrAnswer(_ lable: UILabel) {
        play(song: .corectAnswer)
        lable.backgroundColor = .green
    }
    
    private func setUpWithWrongAnswer(_ lable: UILabel, rightAnswer: Answer) {
        play(song: .wrongAnswer)
        lable.backgroundColor = .red
    }
    
    private func play(song: Music) {
        let urlSoundRow = URL(fileURLWithPath:
                                Bundle.main.path(forResource: song.rawValue,
                                                 ofType: "mp3")!
        )
        
        do {
            player = try AVAudioPlayer(contentsOf: urlSoundRow)
            player.prepareToPlay()
            player.play()
        } catch {
            print("Error getting the audio file")
        }
    }
    
    private func save(answer: Answer) {
        game.userAnswers.append(answer)
    }
    
}

extension GameViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        do {
            try game.goToNextQuestion()
        } catch {
            finishTheGame()
        }
    }

    private func finishTheGame() {
        
    }
}
