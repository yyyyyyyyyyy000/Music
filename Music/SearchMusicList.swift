//
//  SearchMusicList.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/23.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class SearchMusicList: UITableViewController {
    var ids = [Int]()
    var Information = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let WholeSongName = "https://api.imjad.cn/cloudmusic/?type=playlist&id=2011369036"
        let webURL = URL(string: WholeSongName)
        let request = URLRequest(url: webURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            let jsondata = (((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary)["playlist"]) as! NSDictionary)["trackIds"] as! NSArray
            for i in 0...29{
                self.ids.append((jsondata[i] as! NSDictionary)["id"] as! Int)
            }
            for i in 0...29{
                let information = "https://api.imjad.cn/cloudmusic/?type=song&id="+String(self.ids[i])+"&br=128000"
                self.Information.append(information)
            }
            
            
            //test
            let playURL = URL(string: self.Information[0])
            let request = URLRequest(url: playURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) in
              //  let jsondata = (((((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary)["data"]) as! NSArray).firstObject as! NSDictionary)["url"] as! String
                let jsondata = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
                print(jsondata)
                //let newjsondata = URL(string: jsondata)
                //let musicData = try! Data(contentsOf: newjsondata!)
                
            })
            task.resume()
        }
        task.resume()
     
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
     

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
