//
//  GamebordView.swift
//  my2048
//
//  Created by scarlettwang on 2016/4/9.
//  Copyright © 2016年 white. All rights reserved.
//

import UIKit

class GamebordView : UIView {
    var dimension : Int
    var tileWidth : CGFloat
    var tilePadding : CGFloat
    
    let provider = AppearanceProvider()
    
    let tilePopStartScale: CGFloat = 0.1
    let tilePopMaxScale: CGFloat = 1.1
    let tilePopDelay: NSTimeInterval = 0.05
    let tileExpandTime: NSTimeInterval = 0.18
    let tileContractTime: NSTimeInterval = 0.08
    
    let tileMergeStartScale: CGFloat = 1.0
    let tileMergeExpandTime: NSTimeInterval = 0.08
    let tileMergeContractTime: NSTimeInterval = 0.08
    
    let perSquareSlideDuration: NSTimeInterval = 0.08
    
    var tiles : Dictionary<NSIndexPath , TileView>
    
    init(dimension d : Int, titleWidth width : CGFloat, titlePadding padding : CGFloat, backgroundColor : UIColor, foregroundColor : UIColor ) {
        dimension = d
        tileWidth = width
        tilePadding = padding
        tiles = Dictionary()
        let totalWidth = tilePadding + CGFloat(dimension)*(tilePadding + tileWidth)
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
        
        for _ in 0..<dimension{
            yCursor = tilePadding
            for _ in 0..<dimension {
                let tileFrame = UIView(frame : CGRect(x: xCursor, y: yCursor, width: tileWidth, height: tileWidth))
                tileFrame.backgroundColor = forecolor
                tileFrame.layer.cornerRadius = 8
                addSubview(tileFrame)
                yCursor += tilePadding + tileWidth
            }
            xCursor += tilePadding + tileWidth
        }
        
    }
    
    func insertTile(pos : (Int , Int) , value : Int) {
        assert(positionIsValied(pos))
        let (row , col) = pos
        let x = tilePadding + CGFloat(row)*(tilePadding + tileWidth)
        let y = tilePadding + CGFloat(col)*(tilePadding + tileWidth)
        let tileView = TileView(position : CGPointMake(x, y), width: tileWidth, value: value, delegate: provider)
        addSubview(tileView)
        bringSubviewToFront(tileView)
        
        tiles[NSIndexPath(forRow : row , inSection:  col)] = tileView
        
        UIView.animateWithDuration(tileExpandTime, delay: tilePopDelay, options: UIViewAnimationOptions.TransitionNone,
            animations: {
                tileView.layer.setAffineTransform(CGAffineTransformMakeScale(self.tilePopMaxScale, self.tilePopMaxScale))
            },
            completion: { finished in
                UIView.animateWithDuration(self.tileContractTime, animations: { () -> Void in
                tileView.layer.setAffineTransform(CGAffineTransformIdentity)
            })
        })
    }
    
    func positionIsValied(position : (Int , Int)) -> Bool{
        let (x , y) = position
        return x >= 0 && x < dimension && y >= 0 && y < dimension
    }
    
    
}
