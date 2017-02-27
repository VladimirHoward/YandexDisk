//
//  YADPhotoPresenter.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

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
    
    func getModelsCount() -> Int
    {
        return dataSource.count
    }
    
    func loadModels(withOffset offset: Int, and count: Int)
    {
        YADPhotoManager.getPhotos(limit: count, offset: offset, success: { [weak self] (data, jsonOffset) in
            
            DispatchQueue.main.async {
                
                if (self != nil)
                {
                    self?.dataSource.addObjects(from: data as! [Any])
                    self?.jsonModelCount = data.count
                    print("количество объектов после парсинга в Presentere - \(data.count)")
                    self?.view?.reloadData()
                }
                
            }
            
        }, failure: {[weak self] (errorCode) in
        
        })
    }
}
