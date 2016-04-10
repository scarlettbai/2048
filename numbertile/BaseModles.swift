//
//  BaseModles.swift
//  numbertile
//
//  Created by scarlettwang on 2016/4/10.
//  Copyright © 2016年 white. All rights reserved.
//

import Foundation

enum TileEnum {
    case Empty
    case Tile(Int)
}

struct SequenceGamebord<T> {
    var demision : Int
    var tileArray : [T]
    
    init(demision d : Int , initValue : T ){
        self.demision = d
        tileArray = [T](count : d*d , repeatedValue : initValue)
    }
    
    subscript(row : Int , col : Int) -> T {
        get{
            assert(row >= 0 && row < demision && col >= 0 && col < demision)
            return tileArray[demision*row + col]
        }
        set{
            assert(row >= 0 && row < demision && col >= 0 && col < demision)
            tileArray[demision*row + col] = newValue
        }
    }
    
    mutating func setAll(value : T){
        for i in 0..<demision {
            for j in 0..<demision {
                self[i , j] = value
            }
        }
    }
}