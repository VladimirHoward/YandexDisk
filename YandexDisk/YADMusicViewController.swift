//
//  YADMusicViewController.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit

//MARK: lifecycle
class YADMusicViewController: UIViewController
{
    
    let kMusicListCellNib = UINib(nibName: "YADMusicTableViewCell", bundle: nil)
    let kMusicListCellReusableIdentifier = "kMusicTableViewCellReuseIdentifier"
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: YADBasePresenter?
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.register(kMusicListCellNib, forCellReuseIdentifier: kMusicListCellReusableIdentifier)
        
        if (presenter == nil)
        {
            YADDependencyInjector.assignPresenter(forView: self)
        }
    }
}

//MARK: YADBaseView
extension YADMusicViewController: YADBaseView
{
    func assignPresenter(presenter: YADBasePresenter) -> Void
    {
        self.presenter = presenter
        presenter.viewLoaded()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadData() -> Void
    {
        tableView.reloadData()
    }
}

//MARK: DataSource, Delegate
extension YADMusicViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return presenter!.getModelsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.kMusicListCellReusableIdentifier, for: indexPath) as! YADMusicTableViewCell
        let model = self.presenter!.getModel(atIndexPath: indexPath as NSIndexPath) as! YADMusicModel
        
        cell.configureSelf(withModel: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let queueCount = presenter!.getModelsCount()
        var queue = [YADMusicModel]()
        
        //запилить под массив из одной модели, всю логику ебашить в пределах одной модели
        
        for i in 0 ..< queueCount
        {
            let localIndexPath = NSIndexPath(row: i, section: 0)
            let model = self.presenter!.getModel(atIndexPath: localIndexPath) as! YADMusicModel
            queue.append(model)
        }
        
        if queue[indexPath.row].audioURL != ""
        {
            YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
        }
        else
        {
            if (indexPath.row - 1) >= 0 && (indexPath.row + 1) <= (queue.count - 1)
            {
                presenter?.audioGetLink!(withPath: queue[indexPath.row].path, success: {
                
                    self.presenter?.audioGetLink!(withPath: queue[indexPath.row - 1].path, success: {
                    
                        self.presenter?.audioGetLink!(withPath: queue[indexPath.row + 1].path, success: {
                        
                                YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
                            
                        }, failure: {
                            print("error")
                        })
        
                    }, failure: {
                        print("error")
                    })

                }, failure: {
                    print("error")
                })
            }
            else
            {
                presenter?.audioGetLink!(withPath: queue[indexPath.row].path, success: {
                    
                    YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
                    
                }, failure: {
                    print("error")
                })
            }
        }
    }
}
