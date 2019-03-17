//
//  MusicPlayer.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/16.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit
import AVFoundation
class MusicPlayer: UIViewController,UIPopoverPresentationControllerDelegate {
    var theNameOfMusic:String?
    var stylusImage = UIImage(named: "stylus")
    @IBOutlet weak var stylus: UIImageView!{
        didSet{
            stylus.image = stylusImage
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
            let index = MusicModel.shared.namesOfMusic.index(of:theNameOfMusic!)
            ProgressSlider.maximumValue = Float(MusicModel.shared.theTimeOfMusic[index!])
            ProgressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        }
    }
    
    
    @IBOutlet weak var volumeSlider: UISlider!{
        didSet{
            player.volume = volumeSlider.value
            volumeSlider.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
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
             let index = MusicModel.shared.namesOfMusic.index(of:theNameOfMusic!)
            let time = MusicModel.shared.theTimeOfMusic[index!]
            TrackOfTime.text = converTime(time: time)
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
    
    lazy var path = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "mp3")
    lazy var imagePath = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "jpg")
    lazy var player = try! AVAudioPlayer(contentsOf: path!)
    override func viewDidLoad() {
        super.viewDidLoad()
        player.play()
        MainPicture.rotate360DegreeWithImageView(duration: 6, repeatCount: 200)
        time = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {timer in
            self.ProgressSlider.value = Float(self.theCurrentTimeOfMusic)
            self.theCurrentTimeOfMusic += 1
            self.CurrentTimeLabel.text = self.converTime(time: self.theCurrentTimeOfMusic)
            let index = MusicModel.shared.namesOfMusic.index(of:self.theNameOfMusic!)
            if self.theCurrentTimeOfMusic == MusicModel.shared.theTimeOfMusic[index!]{
                switch self.playmode{
                case .sequence:self.resetMusic(newSong: MusicModel.shared.namesOfMusic[(index!+1)%MusicModel.shared.namesOfMusic.count])
                case .random:self.resetMusic(newSong: MusicModel.shared.namesOfMusic[MusicModel.shared.namesOfMusic.count.randomNumber])
                case .cycle: self.resetMusic(newSong: self.theNameOfMusic!)
                }
                
            }
        })
        
    }
    
   
    
    
    @IBAction func LikeOrDislikeThisMusic(_ sender: UIButton) {
        if sender.currentTitle == "🖤"{
            sender.setTitle("❤️", for: .normal)
            MusicModel.shared.theFavoriteSong.append(theNameOfMusic!)
        }else{
            sender.setTitle("🖤", for: .normal)
        }
        
        
    }
    
    @IBOutlet weak var BackGroundImage: UIImageView!{
        didSet{
            let imagePath = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "jpg")
            let data = try! Data(contentsOf: imagePath!)
            BackGroundImage.image = UIImage(data: data)
        }
    }
    
    
    
    @IBOutlet weak var startOrstop: UIButton!
    
    @IBOutlet weak var MainPicture: UIImageView!{
        didSet{
            let data = try! Data(contentsOf: imagePath!)
            MainPicture.image = UIImage(data: data)
       }
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
        let index = MusicModel.shared.namesOfMusic.index(of:theNameOfMusic!)
        let newSong = MusicModel.shared.namesOfMusic[(index!+1)%MusicModel.shared.namesOfMusic.count]
        theNameOfMusic = newSong
        resetMusic(newSong: newSong)
    }
    
    @IBAction func last(_ sender: UIButton) {
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
