//
//  CustomMusicPlayerController.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/19.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit
import  AVFoundation
class CustomMusicPlayerController: UIViewController {
    var theNumberOfSong = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic(SongNumber: theNumberOfSong)
    }
    
    enum MusicType{
        case Cantonese
        case thrill
    }
    
    @IBOutlet weak var MainPicture: UIImageView!{
        didSet{
            var path:URL?
            switch TypeOfMusic!{
            case .Cantonese: path = Bundle.main.url(forResource: "粤语", withExtension: "jpg")
            case .thrill: path = Bundle.main.url(forResource: "抖音", withExtension: "jpg")
            }
            let imageData = try! Data(contentsOf: path!)
            let image = UIImage(data: imageData)
            MainPicture.image = image
            MainPicture.rotate360DegreeWithImageView(duration: 5, repeatCount: 100)
            
            
        }
    }
    
    
    
    
    
    var player:AVAudioPlayer?
    var TypeOfMusic:MusicType?
    
    
    
    @IBOutlet weak var BackGroundImage: UIImageView!{
        didSet{
            var path:URL?
            switch TypeOfMusic!{
            case .Cantonese: path = Bundle.main.url(forResource: "粤语", withExtension: "jpg")
            case .thrill: path = Bundle.main.url(forResource: "抖音", withExtension: "jpg")
            }
            let imageData = try! Data(contentsOf: path!)
            let image = UIImage(data: imageData)
            BackGroundImage.image = image
       }
    }
    
    
    
    var idThatPassedTo:String?
    
    
    
    
    private func playMusic(SongNumber number:Int){
        let id:String?
        switch TypeOfMusic!{
        case .Cantonese:id = "632021463"
        case .thrill:id = "2182872769"
        }
        let WholeSongName = "https://api.imjad.cn/cloudmusic/?type=playlist&id="+id!
        let webURL = URL(string: WholeSongName)
        let request = URLRequest(url: webURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            let jsondata = (((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary)["playlist"]) as! NSDictionary)["trackIds"] as! NSArray
            print(jsondata)
            let id = ((jsondata[number] as! NSDictionary)["id"] as! Int)
            self.idThatPassedTo = String(id)
            let information = "https://api.imjad.cn/cloudmusic/?type=song&id="+String(id)+"&br=128000"
            let playURL = URL(string: information)
            let request = URLRequest(url: playURL!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) in
                let jsondata = (((((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary)["data"]) as! NSArray).firstObject as! NSDictionary)["url"] as! String
                let str = String(data: data!, encoding: .utf8)
                print(str!)
                print("s")
                print(jsondata)
                print("s")
                let newjsondata = URL(string: jsondata)
                let musicData = try! Data(contentsOf: newjsondata!)
                self.player = try! AVAudioPlayer(data: musicData)
                self.player!.play()
            })
            task.resume()
        }
        task.resume()
    }
    
    @IBOutlet weak var PlayOrStop: UIButton!
    @IBAction func PlayOrStop(_ sender: UIButton) {
        if sender.currentTitle == "⏹"{
            sender.setTitle("▶️", for: .normal)
            player?.stop()
        }else{
            sender.setTitle("⏹", for: .normal)
            player?.play()
        }
    }
    
    @IBAction func LastOne(_ sender: UIButton) {
        player?.stop()
        theNumberOfSong -= 1
        playMusic(SongNumber: theNumberOfSong)
    }
    
    
    
    
    
    @IBAction func NextOne(_ sender: UIButton) {
        player?.stop()
        theNumberOfSong += 1
        playMusic(SongNumber: theNumberOfSong)
    }
    
    
    
}




