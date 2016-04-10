//
//  GameModle.swift
//  numbertile
//
//  Created by scarlettwang on 2016/4/10.
//  Copyright © 2016年 white. All rights reserved.
//

import UIKit


class GameModle : NSObject {
    
    let dimension : Int
    let threshold : Int
    
    var gamebord : SequenceGamebord<TileEnum>
    
    unowned let delegate : GameModelProtocol
    
    var score : Int = 0{
        didSet{
            delegate.changeScore(score)
        }
    }
    
    init(dimension : Int , threshold : Int , delegate : GameModelProtocol) {
        self.dimension = dimension
        self.threshold = threshold
        self.delegate = delegate
        gamebord = SequenceGamebord(demision: dimension , initValue: TileEnum.Empty)
        super.init()
    }
    
    
    
    
    
    
    
    
    func insertRandomPositoinTile(value : Int)  {
        let emptyArrays = getEmptyPosition()
        if emptyArrays.isEmpty {
            return
        }
        let randomPos = Int(arc4random_uniform(UInt32(emptyArrays.count - 1)))
        let (x , y) = emptyArrays[randomPos]
        gamebord[(x , y)] = TileEnum.Tile(value)
        delegate.insertTile((x , y), value: value)
    }
    
    func getEmptyPosition() -> [(Int , Int)]  {
        var emptyArrys : [(Int , Int)] = []
        for i in 0..<dimension {
            for j in 0..<dimension {
                if case .Empty = gamebord[i , j] {
                    emptyArrys.append((i , j))
                }
            }
        }
        return emptyArrys
    }
    
}
