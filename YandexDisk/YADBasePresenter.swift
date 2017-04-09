//
//  YADBasePresenter.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import MWPhotoBrowser


@objc protocol YADBasePresenter
{
    func assignView (view: YADBaseView) -> Void
    func viewLoaded () -> Void
    func refreshData () -> Void
    func getModel (atIndexPath indexPath: NSIndexPath) -> Any
    func getModelsCount () -> Int
    func loadModels (withOffset offset: Int, and count: Int) -> Void
    @objc optional func itemGetLink (withModel model: Any, success: @escaping ()->Void, failure: @escaping () -> Void) -> Void
    
    @objc optional func getSimpleModel (atIndexPath indexPath: NSIndexPath) -> Any
    @objc optional func uploadPhoto (WithName path: String, url: String) -> Void
}
