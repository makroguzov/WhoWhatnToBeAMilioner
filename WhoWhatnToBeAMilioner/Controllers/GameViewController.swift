//
//  GameViewController.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import UIKit
import AVFoundation
import JGProgressHUD

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
    
    private var game: Game = .empty
    
    private var player = AVAudioPlayer() {
        didSet {
            player.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        loadData()
    }
    
    private func loadData() {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        NetworkServise.defolt.getQuestions { [weak self] game in
            self?.game = game
            DispatchQueue.main.async {
                self?.setUpWithNewQuestion()
                self?.makeLables(visible: true)
                hud.dismiss(animated: true)
            }
        }
    }
    
    private func setUpWithNewQuestion() {
        let lables = [answer1Lable, answer2Lable, answer3Lable, answer4Lable]
        let answers = game.question.answers.shuffled()
        
        let qwe = zip(lables, answers)
        for (lable, answer) in qwe {
            guard let lable = lable else {
                return
            }
            
            let answer = answer.answer
            
            lable.text = answer
            lable.backgroundColor = .none
            lable.sizeToFit()
        }
        
        let question = game.question.question
        
        questionLable.text = question
        questionLable.sizeToFit()
        
        
        makeLables(isUserInteractionEnabled: true)
    }
    
    private func makeLables(visible: Bool) {
        let lables = [questionLable, answer1Lable, answer2Lable, answer3Lable, answer4Lable]
        lables.forEach({ $0?.isHidden = !visible })
    }
    
    private func makeLables(isUserInteractionEnabled: Bool) {
        let lables = [questionLable, answer1Lable, answer2Lable, answer3Lable, answer4Lable]
        lables.forEach({ $0?.isUserInteractionEnabled = isUserInteractionEnabled })
    }
    
    private func setUp(_ lable: UILabel) {
        lable.layer.cornerRadius = 20
        
        lable.layer.borderWidth = 4
        lable.layer.borderColor = UIColor.blue.cgColor
        lable.clipsToBounds = true

        lable.isUserInteractionEnabled = true
        lable.isHidden = true
        
        lable.layer.shadowColor = UIColor.blue.cgColor
        lable.layer.shadowRadius = 20
        lable.layer.shadowOpacity = 0.8
        lable.layer.shadowOffset = .zero
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLableAction(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        lable.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapLableAction(_ sender: UIGestureRecognizer) {
        guard let lable = sender.view as? UILabel else {
            return
        }
        
        makeLables(isUserInteractionEnabled: false)
        
        let question = game.question
        let userAnswer = lable.text ?? ""
    
        guard let answer = question.answers.filter({ $0 == userAnswer }).first else {
            return
        }
        
        switch answer {
        case .right:
            setUpWithRighrAnswer(lable)
        case .wrong:
            do {
                let rightAnswer = try question.getRightAnswer()
                setUpWithWrongAnswer(lable, rightAnswer: rightAnswer)
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
        
        game.addUserAnswer(answer: answer)
    }
    
    private func setUpWithRighrAnswer(_ lable: UILabel) {
        play(song: .corectAnswer)
        lable.backgroundColor = .green
    }
    
    private func setUpWithWrongAnswer(_ lable: UILabel, rightAnswer: Answer) {
        play(song: .wrongAnswer)
        
        var rightAnswerLable: UILabel?
        let lables = [questionLable, answer1Lable, answer2Lable, answer3Lable, answer4Lable]
        lables.forEach { (lable) in
            if rightAnswer == lable?.text ?? "" {
                rightAnswerLable = lable
            }
        }
        
        rightAnswerLable?.backgroundColor = .green
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
        
}

extension GameViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        do {
            try game.goToNextQuestion()
            setUpWithNewQuestion()
        } catch {
            finishTheGame()
        }
    }
    
    private func finishTheGame() {
        let careTaker = Caretaker()
        careTaker.saveGame(game: game)
        
        dismiss(animated: true)
    }
}
