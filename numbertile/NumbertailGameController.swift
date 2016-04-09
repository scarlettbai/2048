//
//  NumbertailGameController.swift
//  my2048
//
//  Created by scarlettwang on 2016/4/9.
//  Copyright © 2016年 white. All rights reserved.
//

import UIKit

class NumbertailGameController : UIViewController {
    
    var demension : Int
    var threshold : Int
    
    var bord : GamebordView?
    
    // Width of the gameboard
    let boardWidth: CGFloat = 230.0
    // How much padding to place between the tiles
    let thinPadding: CGFloat = 3.0
    
    // Amount of space to place between the different component views (gameboard, score view, etc)
    let viewPadding: CGFloat = 10.0
    // Amount that the vertical alignment of the component views should differ from if they were centered
    let verticalViewOffset: CGFloat = 0.0
    
    init(demension d : Int , threshold t : Int) {
        demension = d < 2 ? 2 : d
        threshold = t < 8 ? 8 : t
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(red : 0xE6/255, green : 0xE2/255, blue : 0xD4/255, alpha : 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }
    
    func setupGame(){
        let viewWidth = view.bounds.size.width
        let viewHeight = view.bounds.size.height
        
        func xposition2Center(view v : UIView) -> CGFloat{
            let vWidth = v.bounds.size.width
            return 0.5*(viewWidth - vWidth)
            
        }
        
        func yposition2Center(order : Int , views : [UIView]) -> CGFloat {
            assert(views.count > 0)
            let totalViewHeigth = CGFloat(views.count - 1)*viewPadding +
                views.map({$0.bounds.size.height}).reduce(verticalViewOffset, combine: {$0 + $1})
            let firstY = 0.5*(viewHeight - totalViewHeigth)
            
            var acc : CGFloat = 0
            for i in 0..<order{
                acc += viewPadding + views[i].bounds.size.height
            }
            return acc + firstY
        }
        
        let width = (boardWidth - thinPadding*CGFloat(demension + 1))/CGFloat(demension)
        
        let gamebord = GamebordView(
            demension : demension,
            titleWidth: width,
            titlePadding: thinPadding,
            backgroundColor:  UIColor(red : 0x90/255, green : 0x8D/255, blue : 0x80/255, alpha : 1),
            foregroundColor:UIColor(red : 0xF9/255, green : 0xF9/255, blue : 0xE3/255, alpha : 0.5)
        )
        
        let views = [gamebord]
        
        var f = gamebord.frame
        f.origin.x = xposition2Center(view: gamebord)
        f.origin.y = yposition2Center(0, views: views)
        gamebord.frame = f
        
        view.addSubview(gamebord)
        
    }
    
}
