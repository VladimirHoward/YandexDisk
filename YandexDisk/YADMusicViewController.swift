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
    
    var currentIndex = 0
    
    static var needToSwitchSong = false
    static var next = false
    static var prev = false
    
    //Refresh Data
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(YADMusicViewController.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    func setupTimer()
    {
        let timer = Timer(timeInterval: 0.001, target: self, selector: #selector(handleSwitchingSong), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    func handleSwitchingSong()
    {
        
        var queue = [YADMusicModel]()

        
        if YADMusicViewController.needToSwitchSong == true && YADMusicViewController.next == true
        {
            guard (currentIndex + 1) <= (presenter?.getModelsCount())! else {
                return
            }
            
            YADMusicViewController.needToSwitchSong = false
            YADMusicViewController.next = false

            let indexPath = NSIndexPath(row: currentIndex + 1, section: 0)
            let model = presenter?.getSimpleModel!(atIndexPath: indexPath) as! YADMusicModel
            print("switching song to song with name - \(model.name)")
            if model.audioURL != ""
            {
                queue.append(model)
                YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
                currentIndex = indexPath.row
            }
            else
            {
                presenter?.itemGetLink!(withModel: model, success: {
                    
                    queue.append(model)
                    YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
                    self.currentIndex = indexPath.row
                    
                }, failure: {
                    print("error in presenter")
                })
            }
        }
        
        if YADMusicViewController.needToSwitchSong == true && YADMusicViewController.prev == true
        {
            guard (currentIndex - 1) >= 0 else {
                return
            }
            
            YADMusicViewController.needToSwitchSong = false
            YADMusicViewController.prev = false

            let indexPath = NSIndexPath(row: currentIndex - 1, section: 0)
            let model = presenter?.getSimpleModel!(atIndexPath: indexPath) as! YADMusicModel
            print("switching song to song with name - \(model.name)")
            if model.audioURL != ""
            {
                queue.append(model)
                YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
                currentIndex = indexPath.row
            }
            else
            {
                presenter?.itemGetLink!(withModel: model, success: {
                    
                    queue.append(model)
                    YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
                    self.currentIndex = indexPath.row
                    
                }, failure: {
                    print("error in presenter")
                })
            }
        }
        
        YADMusicViewController.needToSwitchSong = false
        YADMusicViewController.prev = false
        YADMusicViewController.next = false
    }
    
    func handleRefresh (refreshControl: UIRefreshControl)
    {
        presenter?.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.register(kMusicListCellNib, forCellReuseIdentifier: kMusicListCellReusableIdentifier)
        setupTimer()
        
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
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

//MARK: TableView DataSource, Delegate
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        var queue = [YADMusicModel]()
        print("index - \(indexPath.row)")
        let model = presenter?.getModel(atIndexPath: indexPath as NSIndexPath) as! YADMusicModel
        
        if model.audioURL != ""
        {
            queue.append(model)
            YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
            currentIndex = indexPath.row
        }
        else
        {
            presenter?.itemGetLink!(withModel: model, success: {
                
                queue.append(model)
                YADMusicPlayerView.sharedInstance.playWithQueue(withQueue: queue, index: indexPath.row)
                self.currentIndex = indexPath.row

            }, failure: {
                print("error in presenter")
            })
        }
    }
}
