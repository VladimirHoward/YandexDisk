//
//  YADBaseTabbarController.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit
import StreamingKit
import MediaPlayer

class YADBaseTabbarController: UITabBarController
{
    
    var playerPanel: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        playerPanel = YADMusicPlayerView.sharedInstance
        print("\nclass - \(playerPanel)\n")
        playerPanel.frame = CGRect(x: 0, y: view.frame.size.height-200, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(playerPanel)
        playerPanel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        view.bringSubview(toFront: tabBar)
    }
}

















