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
    
    func reset() {
        for (_, tile) in tiles {
            tile.removeFromSuperview()
        }
        tiles.removeAll(keepCapacity: true)
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
    
    func moveOneTiles(from : (Int , Int)  , to : (Int , Int) , value : Int) {
        let (fx , fy) = from
        let (tx , ty) = to
        let fromKey = NSIndexPath(forRow: fx , inSection: fy)
        let toKey = NSIndexPath(forRow: tx, inSection: ty)
        
        guard let tile = tiles[fromKey] else{
            assert(false, "not exists tile")
        }
        let endTile = tiles[toKey]
        
        var changeFrame = tile.frame
        changeFrame.origin.x = tilePadding + CGFloat(tx)*(tilePadding + tileWidth)
        changeFrame.origin.y = tilePadding + CGFloat(ty)*(tilePadding + tileWidth)
        
        tiles.removeValueForKey(fromKey)
        tiles[toKey] = tile
        
        // Animate
        let shouldPop = endTile != nil
        UIView.animateWithDuration(perSquareSlideDuration,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.BeginFromCurrentState,
                                   animations: {
                                    // Slide tile
                                    tile.frame = changeFrame
            },
                                   completion: { (finished: Bool) -> Void in
                                    tile.value = value
                                    endTile?.removeFromSuperview()
                                    if !shouldPop || !finished {
                                        return
                                    }
                                    tile.layer.setAffineTransform(CGAffineTransformMakeScale(self.tileMergeStartScale, self.tileMergeStartScale))
                                    // Pop tile
                                    UIView.animateWithDuration(self.tileMergeExpandTime,
                                        animations: {
                                            tile.layer.setAffineTransform(CGAffineTransformMakeScale(self.tilePopMaxScale, self.tilePopMaxScale))
                                        },
                                        completion: { finished in
                                            // Contract tile to original size
                                            UIView.animateWithDuration(self.tileMergeContractTime) {
                                                tile.layer.setAffineTransform(CGAffineTransformIdentity)
                                            }
                                    })
        })
    }
    
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(positionIsValid(from.0) && positionIsValid(from.1) && positionIsValid(to))
        let (fromRowA, fromColA) = from.0
        let (fromRowB, fromColB) = from.1
        let (toRow, toCol) = to
        let fromKeyA = NSIndexPath(forRow: fromRowA, inSection: fromColA)
        let fromKeyB = NSIndexPath(forRow: fromRowB, inSection: fromColB)
        let toKey = NSIndexPath(forRow: toRow, inSection: toCol)
        
        guard let tileA = tiles[fromKeyA] else {
            assert(false, "placeholder error")
        }
        guard let tileB = tiles[fromKeyB] else {
            assert(false, "placeholder error")
        }
        
        var finalFrame = tileA.frame
        finalFrame.origin.x = tilePadding + CGFloat(toRow)*(tileWidth + tilePadding)
        finalFrame.origin.y = tilePadding + CGFloat(toCol)*(tileWidth + tilePadding)
        
        let oldTile = tiles[toKey]  
        oldTile?.removeFromSuperview()
        tiles.removeValueForKey(fromKeyA)
        tiles.removeValueForKey(fromKeyB)
        tiles[toKey] = tileA
        
        UIView.animateWithDuration(perSquareSlideDuration,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.BeginFromCurrentState,
                                   animations: {
                                    // Slide tiles
                                    tileA.frame = finalFrame
                                    tileB.frame = finalFrame
            },
                                   completion: { finished in
                                    tileA.value = value
                                    tileB.removeFromSuperview()
                                    if !finished {
                                        return
                                    }
                                    tileA.layer.setAffineTransform(CGAffineTransformMakeScale(self.tileMergeStartScale, self.tileMergeStartScale))
                                    // Pop tile
                                    UIView.animateWithDuration(self.tileMergeExpandTime,
                                        animations: {
                                            tileA.layer.setAffineTransform(CGAffineTransformMakeScale(self.tilePopMaxScale, self.tilePopMaxScale))
                                        },
                                        completion: { finished in
                                            // Contract tile to original size
                                            UIView.animateWithDuration(self.tileMergeContractTime) {
                                                tileA.layer.setAffineTransform(CGAffineTransformIdentity)
                                            }
                                    })
        })
    }
    
    func positionIsValid(pos: (Int, Int)) -> Bool {
        let (x, y) = pos
        return (x >= 0 && x < dimension && y >= 0 && y < dimension)
    }
}
