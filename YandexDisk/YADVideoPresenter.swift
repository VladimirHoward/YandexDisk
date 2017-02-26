//
//  YADVideoPresenter.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADVideoPeresenter: YADBasePresenter
{
    
    private let dataSource = NSMutableArray()
    private var totalCount = 0
    private var pageSize = 20
    private weak var view: YADBaseView?
    
    func assignView(view: YADBaseView)
    {
        self.view = view
    }
    
    func viewLoaded() -> Void
    {
        loadModels(withOffset: 0, and: 20)
        
    }
    
    func refreshData()
    {
        totalCount = 0
        let allCount = dataSource.count
        dataSource.removeAllObjects()
        loadModels(withOffset: 0, and: allCount)
    }
    
    func getModel(atIndexPath indexPath: NSIndexPath) -> Any
    {
        let model = dataSource[indexPath.row] as! YADVideoModel
        print("PRESENTER. indexPath.row - \(indexPath.row), dataSource.count - \(dataSource.count)")
        if (indexPath.row == dataSource.count - 1)
        {
            print("PRESENTER. indexPath.row \(indexPath.row) == \(dataSource.count) - 1 dataSource.count")
            if dataSource.count == totalCount
            {
                return model
            }
            loadModels(withOffset: dataSource.count, and: pageSize)
        }
        
        return model
    }
    
    func getModelsCount() -> Int
    {
        return dataSource.count
    }
    
    func loadModels(withOffset offset: Int, and count: Int)
    {
        YADVideoManager.getVideos(limit: count, offset: offset, success: { [weak self] (data, count) in
            
            DispatchQueue.main.async {
                
                if (self != nil)
                {
                    self?.totalCount = count
                    self?.dataSource.addObjects(from: data as! [Any])
                    print("количество объектов после парсинга в Presentere - \(data.count)")
                    self?.view?.reloadData()
                }
                
            }
            
            }, failure: {[weak self] (errirCode) in
                
        })
    }
}
