//
//  YADPhotoViewController.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit
import HMPhotoBrowser

//MARK: Жизненный цикл
class YADPhotoViewController: UIViewController
{
    let kPhotoListCellNib = UINib(nibName: "YADPhotoCollectionViewCell", bundle: nil)
    let kPhotoListCellReuseIdentifier = "kPhotoListCellReuseIdentifier"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: YADBasePresenter?
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        collectionView.register(kPhotoListCellNib, forCellWithReuseIdentifier: kPhotoListCellReuseIdentifier)
        
        if (presenter == nil)
        {
            YADDependencyInjector.assignPresenter(forView: self)
        }
        else
        {
            presenter?.refreshData()
        }
    }
}

//MARK: процедуры YADBaseView
extension YADPhotoViewController: YADBaseView
{
    func assignPresenter(presenter: YADBasePresenter) -> Void
    {
        self.presenter = presenter
        presenter.viewLoaded()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadData() -> Void
    {
        collectionView.reloadData()
    }
}

//MARK: процедуры DataSource Delegate
extension YADPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        print("\n\nмоделей в массиве в VC - \(presenter!.getModelsCount())")
        return presenter!.getModelsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.kPhotoListCellReuseIdentifier, for: indexPath) as! YADPhotoCollectionViewCell
        let model = self.presenter!.getModel(atIndexPath: indexPath as NSIndexPath) as! YADPhotoModel
//        print("имя файла в VC - \(model.name)\n\n")
        cell.configureSelf(photo: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.width - 4) / 3, height: (collectionView.frame.width - 4) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        let model = self.presenter!.getModel(atIndexPath: indexPath as NSIndexPath) as! YADPhotoModel
//        
//    }

}

//MARK: HMPhotoBrowser delegat




