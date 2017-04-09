//
//  YADMusicPresenter.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADMusicPresenter:YADBasePresenter
{
    private let dataSource = NSMutableArray()
    private let pageSize = 10
    private var jsonModelCount = 0
    private weak var view: YADBaseView?
    
    func assignView(view: YADBaseView)
    {
        self.view = view
    }
    
    func viewLoaded()
    {
        loadModels(withOffset: 0, and: 10)
    }
    
    func refreshData()
    {
        dataSource.removeAllObjects()
        loadModels(withOffset: 0, and: 10)
        self.view?.reloadData()
    }
    
    func getModel(atIndexPath indexPath: NSIndexPath) -> Any
    {
        print("model count - \(dataSource.count)")
        let model = dataSource[indexPath.row] as! YADMusicModel
        
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
        YADMusicManager.getSongs(withLimit: count, offset: offset, success: { [weak self](data) in
            
            DispatchQueue.main.async {
               
                if (self != nil)
                {
                    self?.dataSource.addObjects(from: data as! [Any])
                    self?.jsonModelCount = data.count
                    self?.view?.reloadData()
                }
            }
            
        }) { (errorCode) in
            print("error with code - \(errorCode)")
        }
    }
    
    func itemGetLink(withModel model: Any, success: @escaping () -> Void, failure: @escaping () -> Void)
    {
        
        YADMusicManager.getLink(withPath: (model as! YADMusicModel).path, success: { (downloadLink) in
            
            DispatchQueue.main.async {
                (model as! YADMusicModel).audioURL = downloadLink
                success()
            }
            
        }) { (errorCode) in
            print("error in presenter with code - \(errorCode)")
        }
    }
    
    func getSimpleModel(atIndexPath indexPath: NSIndexPath) -> Any
    {
        let model = dataSource[indexPath.row]
        return model
    }
}
