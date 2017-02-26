//
//  YADDependencyInjector.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADDependencyInjector
{
    class func assignPresenter (forView view: YADBaseView)
    {
        var presenter: YADBasePresenter?
        
        //here your should connect presenter and viewController
        /**
         if (view is *NameOfViewControllerClass*)
         {
         presenter = *NameOfPresenterClassForVC*()
         }
         */
        
        if (view is YADPhotoViewController)
        {
            presenter = YADPhotoPresenter()
        }
        
        if presenter != nil
        {
            view.assignPresenter(presenter: presenter!)
            presenter?.assignView(view: view)
        }
        
    }
}
