//
//  MusicPlayer.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/16.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit
import AVFoundation
class MusicPlayer: UIViewController {
    var musicmodel = MusicModel()
    var theNameOfMusic:String?
    var stylusImage = UIImage(named: "stylus")
    @IBOutlet weak var stylus: UIImageView!{
        didSet{
            stylus.image = stylusImage
        }
    }
    lazy var path = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "mp3")
    lazy var imagePath = Bundle.main.url(forResource: theNameOfMusic!, withExtension: "jpg")
    lazy var player = try! AVAudioPlayer(contentsOf: path!)
    override func viewDidLoad() {
        super.viewDidLoad()
        player.play()
        MainPicture.rotate360DegreeWithImageView(duration: 6, repeatCount: 200)
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
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [.allowUserInteraction], animations: {
                self.stylus.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi*13/8)
            })
            MainPicture.stopRotate()
        }else{
            sender.setTitle("⏹", for: .normal)
            player.play()
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [.allowUserInteraction], animations: {
                self.stylus.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi*16/8)
            })
            MainPicture.rotate360DegreeWithImageView(duration: 6, repeatCount: 200)
        }
    }
    
    @IBAction func nextOne(_ sender: UIButton) {
        let index = musicmodel.namesOfMusic.index(of:theNameOfMusic!)
        let newSong = musicmodel.namesOfMusic[(index!+1)%musicmodel.namesOfMusic.count]
        theNameOfMusic = newSong
        resetMusic(newSong: newSong)
    }
    
    @IBAction func last(_ sender: UIButton) {
        let index = musicmodel.namesOfMusic.index(of:theNameOfMusic!)
        var newSong = ""
        if index == 0{
           newSong = musicmodel.namesOfMusic[musicmodel.namesOfMusic.count-1]
        }else{
           newSong = musicmodel.namesOfMusic[(index!-1)%musicmodel.namesOfMusic.count]
        }
        theNameOfMusic = newSong
        resetMusic(newSong: newSong)
    
}
    private func resetMusic(newSong name:String){
        let new_path = Bundle.main.url(forResource: name, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: new_path!)
        player.play()
        let newimagePath = Bundle.main.url(forResource: name, withExtension: "jpg")
        let data = try! Data(contentsOf: newimagePath!)
        MainPicture.image = UIImage(data: data)
        self.title = name
        if startOrstop.currentTitle == "▶️"{
            startOrstop.setTitle("⏹", for: .normal)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [.allowUserInteraction], animations: {
                self.stylus.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi*16/8)
            })
            MainPicture.rotate360DegreeWithImageView(duration: 6, repeatCount: 200)
        }
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
