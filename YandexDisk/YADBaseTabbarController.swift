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
    
    var translationTo: CGFloat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        playerPanel = YADMusicPlayerView.sharedInstance
        print("\nclass - \(playerPanel)\n")
        playerPanel.frame = CGRect(x: 0, y: view.frame.size.height - 98, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(playerPanel)
        playerPanel.isHidden = true
        
        print("tabbar height - \(tabBar.frame.size.height)")
        print("view height - \(view.frame.size.height)")

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector (YADBaseTabbarController.handlePan(recognizer:)))
        playerPanel.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        view.bringSubview(toFront: tabBar)
    }
    
    func handlePan (recognizer: UIPanGestureRecognizer)
    {
        let translation = recognizer.translation(in: playerPanel)
        playerPanel.frame.origin.y += translation.y
        recognizer.setTranslation(CGPoint.zero, in: playerPanel)
        
        if recognizer.state == .changed
        {
            translationTo = translation.y
        }
        
        if recognizer.state == .ended
        {
            autoExec(translation: translation)
        }
    }
    
    func autoExec(translation: CGPoint)
    {
        let playerPanelOrigin = playerPanel.frame.origin.y
        
        if translationTo <= 0
        {
            if playerPanelOrigin / view.frame.size.height <= 0.75
            {
                panelUp()
            }
            else
            {
                panelDown()
            }
        }
        else
        {
            if playerPanelOrigin / view.frame.size.height <= 0.75
            {
                panelDown()
            }
        }
    }
    
    func panelUp()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.playerPanel.frame.origin.y = -49
        })
    }
    
    func panelDown()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.playerPanel.frame.origin.y = self.view.frame.size.height - 98
        })
    }
}

















