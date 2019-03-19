//
//  MusicPlayer.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/16.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit
import AVFoundation
class MusicPlayer: UIViewController,UIPopoverPresentationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
   
    
    
    
    var theNameOfMusic:String?
    var stylusImage = UIImage(named: "stylus")
    @IBOutlet weak var stylus: UIImageView!{
        didSet{
            stylus.image = stylusImage
        }
    }
    
    @IBOutlet weak var lyricsList: UITableView!{
        didSet{
            lyricsList.separatorStyle = UITableViewCell.SeparatorStyle.none
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(changeToPlayer))
            lyricsList.addGestureRecognizer(tapgesture)
        }
    }
   
    
    
    
    
    enum playMode{
        case random
        case sequence
        case cycle
    }
    
    var playmode = playMode.sequence
    
    
    @IBOutlet weak var randomOrsequencePlay: UIButton!{
        didSet{
            switch playmode{
            case .random: randomOrsequencePlay.setTitle("🔀", for: .normal)
            case .sequence: randomOrsequencePlay.setTitle("🔁", for: .normal)
            case .cycle:randomOrsequencePlay.setTitle("🔂", for: .normal)
            }
        }
    }
    
    @IBAction func ChangeTheModeOfPlay(_ sender: UIButton) {
        switch playmode{
        case .sequence:sender.setTitle("🔀", for: .normal);playmode = .random
        case .random:sender.setTitle("🔂", for: .normal); playmode = .cycle
        case .cycle:sender.setTitle("🔁", for: .normal);playmode = .sequence
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? FavoriteSongsTable
        if let ppc = destination?.popoverPresentationController{
            ppc.delegate = self
        }
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    var time: Timer!
    var theCurrentTimeOfMusic = 0
    
    
    @IBOutlet weak var ProgressSlider: UISlider!{
        didSet{
            ProgressSlider.minimumValue = 0
            if searchMusic == nil{
            let index = MusicModel.shared.namesOfMusic.index(of:theNameOfMusic!)
            ProgressSlider.maximumValue = Float(MusicModel.shared.theTimeOfMusic[index!])
            ProgressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            }
        }
    }
    
    
    @IBOutlet weak var volumeSlider: UISlider!{
        didSet{
            if searchMusic == nil{
            player.volume = volumeSlider.value
            volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
            }
        }
    }
    
    @objc private func volumeChanged(_ sender:UISlider){
        player.volume = sender.value
    }
    
    
    @IBOutlet weak var LikeOrDislikeLabel: UIButton!
    
    private func converTime(time:Int)->String{
        let minute = time/60
        let seconds = time-minute*60
        if seconds > 9 {
            return "\(minute)"+":"+"\(seconds)"
        }else{
            return "\(minute)"+":0"+"\(seconds)"
        }
    }
    
    
    @IBOutlet weak var TrackOfTime: UILabel!{
        didSet{
            if searchMusic == nil{
            let index = MusicModel.shared.namesOfMusic.index(of:theNameOfMusic!)
            let time = MusicModel.shared.theTimeOfMusic[index!]
            TrackOfTime.text = converTime(time: time)
            }
        }
    }
    
    @IBOutlet weak var CurrentTimeLabel: UILabel!{
        didSet{
            CurrentTimeLabel.text = converTime(time: 0)
        }
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider){
        let currenttimeOfNewSlider = Int(sender.value)
        theCurrentTimeOfMusic = currenttimeOfNewSlider
        player.currentTime = Double(theCurrentTimeOfMusic)
    }
    var weburl:URL?
    var str:String?
    var searchMusic:String?{
        didSet{
            str = "https://api.bzqll.com/music/tencent/url?key=579621905&id="+searchMusic!+"&br=320"
            weburl = URL(string:str!)
            let request = URLRequest(url: weburl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
                self.searchplayer = try! AVAudioPlayer(data: data!)
            }
            task.resume()
            
        }
    }
    var searchplayer:AVAudioPlayer?
    lazy var path = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "mp3")
    lazy var imagePath = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "jpg")
    lazy var player = try! AVAudioPlayer(contentsOf: path!)
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchMusic == nil{
        player.play()
        }else{
            searchplayer!.play()
        }
        MainPicture.rotate360DegreeWithImageView(duration: 6, repeatCount: 200)
        time = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {timer in
            self.ProgressSlider.value = Float(self.theCurrentTimeOfMusic)
            self.theCurrentTimeOfMusic += 1
            if self.theCurrentTimeOfMusic >= 10{
                self.lyricsList.scrollToRow(at: IndexPath(row: self.theCurrentTimeOfMusic/10-1, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            }
            self.CurrentTimeLabel.text = self.converTime(time: self.theCurrentTimeOfMusic)
            if self.searchMusic == nil{
            let index = MusicModel.shared.namesOfMusic.index(of:self.theNameOfMusic!)
            if self.theCurrentTimeOfMusic == MusicModel.shared.theTimeOfMusic[index!]{
                switch self.playmode{
                case .sequence:self.resetMusic(newSong: MusicModel.shared.namesOfMusic[(index!+1)%MusicModel.shared.namesOfMusic.count])
                case .random:self.resetMusic(newSong: MusicModel.shared.namesOfMusic[MusicModel.shared.namesOfMusic.count.randomNumber])
                case .cycle: self.resetMusic(newSong: self.theNameOfMusic!)
                }
                
                }}
        })
        lyricsList.delegate = self
        lyricsList.dataSource = self
    }
    
    
    
    
    @IBAction func LikeOrDislikeThisMusic(_ sender: UIButton) {
        if searchMusic == nil{
        if sender.currentTitle == "🖤"{
            sender.setTitle("❤️", for: .normal)
            MusicModel.shared.theFavoriteSong.append(theNameOfMusic!)
        }else{
            sender.setTitle("🖤", for: .normal)
        }
        }
        
        
    }
    
    @IBOutlet weak var BackGroundImage: UIImageView!{
        didSet{
            if searchMusic == nil{
            let imagePath = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "jpg")
            let data = try! Data(contentsOf: imagePath!)
            BackGroundImage.image = UIImage(data: data)
            }
        }
    }
    
    
    
    @IBOutlet weak var startOrstop: UIButton!
    
    @IBOutlet weak var MainPicture: UIImageView!{
        didSet{
            if searchMusic == nil{
            let data = try! Data(contentsOf: imagePath!)
                MainPicture.image = UIImage(data: data)
            }
            let tapGestureRecognize = UITapGestureRecognizer(target: self, action: #selector(changeTolyrics))
            MainPicture.addGestureRecognizer(tapGestureRecognize)
        }
    }
    @objc private func changeTolyrics(){
        lyricsList.isHidden = false
        lyricsList.alpha = 0
        stylus.isHidden = true
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
            self.MainPicture.alpha = 0
            self.lyricsList.alpha = 0.3
        }, completion: {  _ in
            self.MainPicture.isHidden = true
        })
        
        
    }
    @objc private func changeToPlayer(){
        MainPicture.isHidden = false
        MainPicture.alpha = 0
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
            self.MainPicture.alpha = 1
            self.lyricsList.alpha = 0
        },completion:{_ in
            self.stylus.isHidden = false
            self.lyricsList.isHidden = true
        })
        
        
    }
    
    @IBAction func PlayOrStop(_ sender: UIButton) {
        if sender.currentTitle == "⏹"{
            sender.setTitle("▶️", for: .normal)
            player.stop()
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                self.stylus.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi*13/8)
            })
            MainPicture.stopRotate()
        }else{
            sender.setTitle("⏹", for: .normal)
            player.play()
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                self.stylus.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi*16/8)
            })
            MainPicture.rotate360DegreeWithImageView(duration: 6, repeatCount: 200)
        }
    }
    
    @IBAction func nextOne(_ sender: UIButton) {
        if searchMusic == nil{
        let index = MusicModel.shared.namesOfMusic.index(of:theNameOfMusic!)
        let newSong = MusicModel.shared.namesOfMusic[(index!+1)%MusicModel.shared.namesOfMusic.count]
        theNameOfMusic = newSong
        resetMusic(newSong: newSong)
        }
    }
    
    @IBAction func last(_ sender: UIButton) {
        if searchMusic == nil{
        let index = MusicModel.shared.namesOfMusic.index(of:theNameOfMusic!)
        var newSong = ""
        if index == 0{
            newSong = MusicModel.shared.namesOfMusic[MusicModel.shared.namesOfMusic.count-1]
        }else{
            newSong = MusicModel.shared.namesOfMusic[(index!-1)%MusicModel.shared.namesOfMusic.count]
        }
        theNameOfMusic = newSong
            resetMusic(newSong: newSong)
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lyrics", for: indexPath)
        if indexPath.row < MusicModel.shared.lyricsOfOneMusic.count{
            cell.textLabel?.text = MusicModel.shared.lyricsOfOneMusic[indexPath.row]
        }else{
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    
    
    
    
    private func resetMusic(newSong name:String){
        theNameOfMusic = name
        let new_path = Bundle.main.url(forResource: name, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: new_path!)
        player.play()
        let newimagePath = Bundle.main.url(forResource: name, withExtension: "jpg")
        let data = try! Data(contentsOf: newimagePath!)
        MainPicture.image = UIImage(data: data)
        BackGroundImage.image = UIImage(data:data)
        self.title = name
        if startOrstop.currentTitle == "▶️"{
            startOrstop.setTitle("⏹", for: .normal)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                self.stylus.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi*16/8)
            })
            MainPicture.rotate360DegreeWithImageView(duration: 6, repeatCount: 200)
        }
        if MusicModel.shared.theFavoriteSong.contains(name){
            LikeOrDislikeLabel.setTitle("❤️", for: .normal)
        }else{
            LikeOrDislikeLabel.setTitle("🖤", for: .normal)
        }
        ProgressSlider.value = 0
        CurrentTimeLabel.text = "0:00"
        theCurrentTimeOfMusic = 0
        let index = MusicModel.shared.namesOfMusic.index(of:name)
        TrackOfTime.text = converTime(time:MusicModel.shared.theTimeOfMusic[index!])
        ProgressSlider.maximumValue = Float(MusicModel.shared.theTimeOfMusic[index!])
    }
    @IBAction func returnBackToplay(segue:UIStoryboardSegue){
        let resourceVC = segue.source as? FavoriteSongsTable
        resetMusic(newSong: (resourceVC?.name!)!)
        print((resourceVC?.name!)!)
    }
    
    
}


extension UIImageView{
    func rotate360DegreeWithImageView(duration:CFTimeInterval , repeatCount :CGFloat ) {
        //让其在z轴旋转
        let rotationAnimation  = CABasicAnimation(keyPath: "transform.rotation.z")
        //旋转角度
        rotationAnimation.toValue = NSNumber(value:  Double.pi * 2.0 )
        //旋转周期
        rotationAnimation.duration = duration;
        //旋转累加角度
        rotationAnimation.isCumulative = true;
        //旋转次数
        rotationAnimation.repeatCount = Float(repeatCount);
        self.layer .add(rotationAnimation, forKey: "rotationAnimation")
    }
    //停止旋转
    func stopRotate() {
        self.layer.removeAllAnimations()
    }
}
extension Int{
    var randomNumber:Int{
        return Int(arc4random_uniform(UInt32(self)))
    }
}
