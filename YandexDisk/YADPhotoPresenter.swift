//
//  YADPhotoPresenter.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import MBProgressHUD
import MWPhotoBrowser

class YADPhotoPresenter: YADBasePresenter
{
    
    private var dataSource = NSMutableArray()
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
        loadModels(withOffset: 0, and: dataSource.count)
    }
    
    func getModel(atIndexPath indexPath: NSIndexPath) -> Any
    {
        let model = dataSource[indexPath.row] as! YADPhotoModel
        
        print("")
        
        if (indexPath.row == dataSource.count - 1)
        {
            
            if jsonModelCount == 0
            {
                return model
            }
            
            loadModels(withOffset: dataSource.count, and: pageSize)
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
    
    func itemGetLink(withModel model: Any, success: @escaping () -> Void, failure: @escaping () -> Void)
    {
        print("model in PhotoGetLink - \((model as! YADPhotoModel).name)")
        YADPhotoManager.getLink(withPath: (model as! YADPhotoModel).path, success: { (downloadLink) in
            
            DispatchQueue.main.async {
                (model as! YADPhotoModel).fullSizeURL = downloadLink
                success()
            }
            
        }) { (errorCode) in
            print("error with code - \(errorCode)")
        }
    }
    
    func loadModels(withOffset offset: Int, and count: Int)
    {
        YADPhotoManager.getPhotos(limit: count, offset: offset, success: { [weak self] (data, jsonOffset) in
            
            DispatchQueue.main.async {
            
                if (self != nil)
                {
                    if offset == 0
                    {
                        self?.dataSource = NSMutableArray (array: data)
                    }
                    else
                    {
                        self?.dataSource.addObjects(from: data as! [Any])
                    }
                    
                    self?.jsonModelCount = data.count
                    
                    print("количество моделей - \(data.count)")
                    
                    self?.view?.reloadData()
                }
            }
        }, failure: {(errorCode) in
        
        })
    }
    
    func uploadPhoto(WithName path: String, url: String)
    {
        YADPhotoManager.uploadPhoto(withName: path, url: url, success: { (uploadHref) in
            
            let request = NSMutableURLRequest()
            request.httpMethod = "PUT"
            let urlToUpload = URL(string: uploadHref)
    
            request.url = urlToUpload
            
            let fileURL = URL(fileURLWithPath: url)
            
            let task = URLSession.shared.uploadTask(with: request as URLRequest, fromFile: fileURL)
            
            task.resume()
            
        }) { (errorCode) in
            
        }
    }
}
