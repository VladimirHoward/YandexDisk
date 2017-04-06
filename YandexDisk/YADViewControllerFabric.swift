//
//  YADViewControllerFabric.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit

class YADViewControllerFabric
{
    class func getViewController (withIdentifier identifier: String) -> UIViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
