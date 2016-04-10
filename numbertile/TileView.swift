//
//  TileView.swift
//  numbertile
//
//  Created by scarlettwang on 2016/4/10.
//  Copyright © 2016年 white. All rights reserved.
//

import UIKit

class TileView : UIView{

    var value : Int = 0 {
        didSet{
            backgroundColor = delegate.tileColor(value)
            lable.textColor = delegate.numberColor(value)
            lable.text = "\(value)"
        }
    }
    
    unowned let delegate : AppearanceProviderProtocol
    
    var lable : UILabel

    init(position : CGPoint, width : CGFloat, value : Int, delegate d: AppearanceProviderProtocol){
        delegate = d
        lable = UILabel(frame : CGRectMake(0 , 0 , width , width))
        lable.textAlignment = NSTextAlignment.Center
        lable.minimumScaleFactor = 0.5
        lable.font = UIFont(name: "HelveticaNeue-Bold", size: 15) ?? UIFont.systemFontOfSize(15)
        super.init(frame: CGRectMake(position.x, position.y, width, width))
        addSubview(lable)
        lable.layer.cornerRadius = 6
        
        self.value = value
        backgroundColor = delegate.tileColor(value)
        lable.textColor = delegate.numberColor(value)
        lable.text = "\(value)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


