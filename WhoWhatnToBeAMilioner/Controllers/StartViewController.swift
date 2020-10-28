//
//  StartViewController.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 28.10.2020.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {

    @IBOutlet weak var recordsButton: UIButton! {
        didSet {
            setUp(recordsButton)
        }
    }
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            setUp(startButton)
        }
    }
    
    private var player: AVAudioPlayer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playMusic()
    }
    
    private func setUp(_ button: UIButton) {
        button.layer.cornerRadius = 20
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowColor = UIColor.blue.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            print("Can't find segue identifier.")
            return
        }
        
        switch identifier {
        case "StartTheGame":
            player.stop()
        default:
            return
        }
    }
    
    private func playMusic() {
        let urlSoundRow = URL(fileURLWithPath:
                                Bundle.main.path(forResource: Music.background.rawValue,
                                                 ofType: "mp3")!
        )
        
        do {
            player = try AVAudioPlayer(contentsOf: urlSoundRow)
            player.prepareToPlay()
            player.numberOfLoops = -1
            player.play()
        } catch {
            print("Error getting the audio file")
        }
    }
    
}
