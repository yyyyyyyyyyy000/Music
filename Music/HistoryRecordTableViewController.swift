//
//  HistoryRecordTableViewController.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/20.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class HistoryRecordTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIImageView(image: UIImage(named: "地球"))
        tableView.backgroundView = view
        view.alpha = 0.8
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicModel.shared.RecordsOfSongs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath)
        cell.textLabel?.text = MusicModel.shared.RecordsOfSongs[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! UINavigationController
        let finalDestination = destination.visibleViewController as! MusicPlayer
        let indexpath = tableView.indexPath(for: sender as! UITableViewCell)
        let SongName = MusicModel.shared.RecordsOfSongs[(indexpath?.row)!]
        finalDestination.theNameOfMusic = SongName
    }

}
