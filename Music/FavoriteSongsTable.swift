//
//  FavoriteSongsTable.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/17.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class FavoriteSongsTable: UITableViewController {
    
    
    var name:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicModel.shared.theFavoriteSong.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesongs", for: indexPath)
        cell.textLabel?.text = MusicModel.shared.theFavoriteSong[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MusicModel.shared.theFavoriteSong.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? UITableViewCell
        let indexpath = tableView.indexPath(for:cell!)
        name = MusicModel.shared.theFavoriteSong[(indexpath?.row)!]
        
    }
 

}
