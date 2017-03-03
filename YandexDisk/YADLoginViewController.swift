//
//  YADLoginViewController.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//
//dev commit
//photo commit

import UIKit

class YADLoginViewController: UIViewController
{
    @IBOutlet weak var webView: UIWebView!
    
    var lock = false
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if (!lock)
        {
            login()
//            print("1. запустили логин во вьюхе")
        }
    }
    
    private func login ()
    {
        lock = true
        
        YADLoginManager.sharedInstance.login(withUnderlayController: webView, success: {
            
//            print("2? полезли в success YADLoginManager")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
            {
                self.performSegue(withIdentifier: YADConst.UIConsts.kLoginTabbarSegueIdentifier, sender: self)
            }
            
        }, failure: {
            
            let alertVC = UIAlertController(title: nil, message: "Не удалось войти", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alertVC.addAction(alertAction)
            self.present(alertVC, animated: true, completion: nil)
        })
    }
    
}
