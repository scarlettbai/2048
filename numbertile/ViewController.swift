//
//  ViewController.swift
//  numbertile
//
//  Created by scarlettwang on 2016/4/9.
//  Copyright © 2016年 white. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setupGame(sender: UIButton) {
        let game = NumbertailGameController(dimension : 4 , threshold: 2048)
        self.presentViewController(game, animated: true , completion: nil)
    }

}

