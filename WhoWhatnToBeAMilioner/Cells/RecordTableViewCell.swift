//
//  RecordTableViewCell.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 01.11.2020.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    static let identifier = "RecordTableViewCell"
    static let nibName = "RecordTableViewCell"
    
    @IBOutlet weak var recordLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUp(with game: Game) {
        recordLable.text = String(game.score)
    }
    
}
