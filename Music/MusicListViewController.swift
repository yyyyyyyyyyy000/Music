//
//  MusicListViewController.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/18.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var SearchField: UITextField!{
        didSet{
            SearchField.delegate = self
        }
    }
    var searchMusic:String?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let TempsongName = textField.text
        textField.text = ""
        
        let WholeSongName = "https://api.bzqll.com/music/tencent/search?key=579621905&s="+TempsongName!+"&limit=100&offset=0&type=song"
        let webURL = URL(string: WholeSongName)
        let request = URLRequest(url: webURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            let jsondata = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let fetchdata = (jsondata["data"] as! NSArray).firstObject as! NSDictionary
            let songID = fetchdata["id"] as! String
            self.searchMusic = songID
            self.performSegue(withIdentifier: "search", sender: AnyClass.self)
        }
        task.resume()
    }
    
    
    
    
    
    
    @IBOutlet weak var ListTablView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListTablView.delegate = self
        ListTablView.dataSource = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "normal":
            let cell = sender as? UITableViewCell
            let indexpath = self.ListTablView.indexPath(for: cell!)
            if let destination = segue.destination as? MusicPlayer{
                destination.title = MusicModel.shared.namesOfMusic[indexpath?.row ?? 0]
                destination.theNameOfMusic = MusicModel.shared.namesOfMusic[indexpath?.row ?? 0]
            }
        case "search":
            let destination = segue.destination as? MusicPlayer
            destination!.searchMusic = searchMusic!
        case "粤语":
            let destination = segue.destination as! UITabBarController
            let FinalDestination = destination.viewControllers?.first as! CustomMusicPlayerController
            FinalDestination.TypeOfMusic = CustomMusicPlayerController.MusicType.Cantonese
        case "抖音":
            let destination = segue.destination as! UITabBarController
            let FinalDestination = destination.viewControllers?.first as! CustomMusicPlayerController
            FinalDestination.TypeOfMusic = CustomMusicPlayerController.MusicType.thrill
        default:break
            }
        }
        
        
        
        
        
    
            
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicModel.shared.namesOfMusic.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "music", for: indexPath)
        cell.textLabel?.text = MusicModel.shared.namesOfMusic[indexPath.row]
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
