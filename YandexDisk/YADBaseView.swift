//
//  YADBaseView.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import UIKit

class YADBaseViewController:UIViewController
{
    func test()
    {
        
    }
}

@objc protocol YADBaseView
{
    func assignPresenter (presenter: YADBasePresenter) -> Void
    func reloadData () -> Void
}
