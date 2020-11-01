//
//  RecordsViewController.swift
//  WhoWhatnToBeAMilioner
//
//  Created by Валерий Макрогузов on 01.11.2020.
//

import UIKit

class RecordsViewController: UITableViewController {

    private var games = [Game]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: RecordTableViewCell.nibName, bundle: nil),
                    forCellReuseIdentifier: RecordTableViewCell.identifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self

        let careTaker = Caretaker()
        games = careTaker.getGames()
    }
    
}

//MARK: UITableViewDelegate

extension RecordsViewController {
    
}

//MARK: UITableViewDataSource

extension RecordsViewController {
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier) as? RecordTableViewCell else {
            fatalError()
        }
        
        let game = games[indexPath.row]
        cell.setUp(with: game)
        
        return cell
    }
    
}
