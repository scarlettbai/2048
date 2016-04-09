//
//  GamebordView.swift
//  my2048
//
//  Created by scarlettwang on 2016/4/9.
//  Copyright © 2016年 white. All rights reserved.
//

import UIKit

class GamebordView : UIView {
    var demension : Int
    var tileWidth : CGFloat
    var tilePadding : CGFloat
    
    init(demension d : Int, titleWidth width : CGFloat, titlePadding padding : CGFloat, backgroundColor : UIColor, foregroundColor : UIColor ) {
        demension = d
        tileWidth = width
        tilePadding = padding
        let totalWidth = tilePadding + CGFloat(demension)*(tilePadding + tileWidth)
        super.init(frame : CGRectMake(0, 0, totalWidth, totalWidth))
        setColor(backgroundColor: backgroundColor , foregroundColor: foregroundColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(backgroundColor bgcolor : UIColor, foregroundColor forecolor : UIColor){
        self.backgroundColor = bgcolor
        var xCursor = tilePadding
        var yCursor : CGFloat
        
        for _ in 0..<demension{
            yCursor = tilePadding
            for _ in 0..<demension {
                let tileFrame = UIView(frame : CGRect(x: xCursor, y: yCursor, width: tileWidth, height: tileWidth))
                tileFrame.backgroundColor = forecolor
                tileFrame.layer.cornerRadius = 8
                addSubview(tileFrame)
                yCursor += tilePadding + tileWidth
            }
            xCursor += tilePadding + tileWidth
        }
        
    }
    
    
}
