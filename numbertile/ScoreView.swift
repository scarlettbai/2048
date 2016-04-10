//
//  ScoreView.swift
//  numbertile
//
//  Created by scarlettwang on 2016/4/9.
//  Copyright © 2016年 white. All rights reserved.
//

import UIKit

protocol ScoreProtocol{
    func scoreChanged(newScore s : Int)
}

class ScoreView : UIView , ScoreProtocol{

    var lable : UILabel
    
    var score : Int = 0{
        didSet{
            lable.text = "SCORE:\(score)"
        }
    }
    
    let defaultFrame = CGRectMake(0, 0, 140, 40)
    
    init(backgroundColor bgColor : UIColor, textColor tColor : UIColor , font : UIFont){
        lable = UILabel(frame : defaultFrame)
        lable.textAlignment = NSTextAlignment.Center
        super.init(frame : defaultFrame)
        backgroundColor = bgColor
        lable.textColor = tColor
        lable.font = font
        lable.layer.cornerRadius = 6
        self.addSubview(lable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scoreChanged(newScore s : Int){
        score = s
    }

}
