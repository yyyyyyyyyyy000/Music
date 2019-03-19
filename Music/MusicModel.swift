//
//  MusicModel.swift
//  Music
//
//  Created by 无敌帅的yyyyy on 2019/3/16.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import Foundation
class MusicModel{
    var namesOfMusic = ["2U","孤岛","不将就","曹操"]
    var theTimeOfMusic = [194,279,313,242]
    
    
    var theFavoriteSong = [String]()

    static var shared = MusicModel()
    
    lazy var lyricsOfOneMusic = [String]()
    
    init(){
        let Alllyrics1 = "那时候 我以为爱的是生活."
        let Alllyrics2 = "也算懂得 什么适合什么不可."
        let Alllyrics3 = "最近还是一样努力着.配合你的性格."
        let Alllyrics4 = "你的追求者 你的坎坷.我开的车."
        let Alllyrics5 = "算一算 虚度了多少个年头.彷佛足够写一套错爱的春秋."
        let Alllyrics6 = "如果以后 你还想为谁.浪费美好时候."
        let Alllyrics7 = "眼泪只能在我的胸膛.毫无保留."
        let Alllyrics8 = "互相折磨到白头.悲伤坚决不放手."
        let Alllyrics9 = "开始纠缠之后.才又被人放大了自由."
        let Alllyrics10 = "你的暴烈太温柔.感情又痛又享受."
        let Alllyrics11 = "如果我说不吻你不罢休.谁能逼我将就."
        lyricsOfOneMusic += [Alllyrics1,Alllyrics2,Alllyrics3,Alllyrics4,Alllyrics5,Alllyrics6,Alllyrics7,Alllyrics8,Alllyrics9,Alllyrics10,Alllyrics11]
        lyricsOfOneMusic += lyricsOfOneMusic
      
            }
        }
        
        
        
        

    

