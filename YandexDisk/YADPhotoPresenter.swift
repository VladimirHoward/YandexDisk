//
//  YADPhotoPresenter.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import MBProgressHUD

class YADPhotoPresenter: YADBasePresenter
{
    
    private let dataSource = NSMutableArray()
    private var jsonModelCount = 0
    private var pageSize = 10
    private weak var view: YADBaseView?
    
    func assignView(view: YADBaseView)
    {
        self.view = view
    }
    
    func viewLoaded() -> Void
    {
        loadModels(withOffset: 0, and: 10)
    }
    
    func refreshData()
    {
        let allCount = dataSource.count
        dataSource.removeAllObjects()
        loadModels(withOffset: 0, and: allCount)

    }
    
    func getModel(atIndexPath indexPath: NSIndexPath) -> Any
    {
        let model = dataSource[indexPath.row] as! YADPhotoModel
        
        if (indexPath.row == dataSource.count - 1)
        {
        
            if jsonModelCount == pageSize
            {
                loadModels(withOffset: dataSource.count, and: pageSize)
            }
            
            if jsonModelCount < pageSize
            {
                return model
            }
            
            if jsonModelCount == 0
            {
                return model
            }
        }
        
        return model
    }
    
    func getSimpleModel(atIndexPath indexPath: NSIndexPath) -> Any
    {
        let model = dataSource[indexPath.row] as! YADPhotoModel
        return model
    }
    
    func getModelsCount() -> Int
    {
        return dataSource.count
    }
    
    func photoGetLink(withPath path: String, hud: MBProgressHUD)
    {
        YADPhotoManager.getLink(withPath: path, success: {[weak self](downloadLink) in
            
            for model in (self?.dataSource)!
            {
                if (model as! YADPhotoModel).fullSizeURL == ""
                {
                    if (model as! YADPhotoModel).path == path
                    {
                        DispatchQueue.main.async {
                            
                            (model as! YADPhotoModel).fullSizeURL = downloadLink
                            hud.hide(true)
                            hud.removeFromSuperViewOnHide = true
                        }
                    }
                }
            }
            
        }) { (errorCode) in
        }
    }
    
    func loadModels(withOffset offset: Int, and count: Int)
    {
        YADPhotoManager.getPhotos(limit: count, offset: offset, success: { [weak self] (data, jsonOffset) in
            
            DispatchQueue.main.async {
            
                if (self != nil)
                {
                    self?.dataSource.addObjects(from: data as! [Any])
                    self?.jsonModelCount = data.count
                    self?.view?.reloadData()
                }
            }
        }, failure: {[weak self] (errorCode) in
        
        })
    }
    
    func uploadPhoto(WithName path: String, url: String)
    {
        YADPhotoManager.uploadPhoto(withName: path, url: url, success: { (uploadHref) in
            
            print("uploadHref - \(uploadHref)")
            
            let request = NSMutableURLRequest()
            request.httpMethod = "PUT"
            request.url = URL(string: uploadHref)
            
            if let fileURL = URL(string: url)
            {
                let task = URLSession.shared.uploadTask(with: request as URLRequest, fromFile: fileURL)
                task.resume()
            }
            
        }) { (errorCode) in
            
        }
    }
}
