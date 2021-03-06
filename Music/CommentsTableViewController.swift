//
//  CommentsTableViewController.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/19.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var id:String?
    
    var strArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        for _ in 0...30{
            let str = ""
            strArray.append(str)
        }
        let id = (tabBarController?.viewControllers![0] as! CustomMusicPlayerController).idThatPassedTo
        let str = "https://api.imjad.cn/cloudmusic/?type=comments&id="+id!
        let webURL = URL(string: str)
        let request = URLRequest(url: webURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            let jsondata = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary)["comments"] as! NSArray
            DispatchQueue.main.async {
                for i in 0..<10{
                    let dic = (jsondata[i] as! NSDictionary)["content"] as! String
                    let str = String(unicodeScalarLiteral: dic)
                    print(str)
                    self.strArray[i] = str
                }
                self.tableView.reloadData()
            }
            
            
        }
        task.resume()
        
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath)
       
        cell.textLabel?.text = strArray[indexPath.row]
        
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
