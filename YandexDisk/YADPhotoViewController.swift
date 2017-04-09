//
//  YADPhotoViewController.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import SDWebImage
import MBProgressHUD
import Photos


//MARK: Жизненный цикл
class YADPhotoViewController: UIViewController
{
    let kPhotoListCellNib = UINib(nibName: "YADPhotoCollectionViewCell", bundle: nil)
    let kPhotoListCellReuseIdentifier = "kPhotoListCellReuseIdentifier"
    
    let imagePicker = UIImagePickerController()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(YADPhotoViewController.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    var browser : MWPhotoBrowser?
    
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = "Фото"
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView.addSubview(self.refreshControl)
        self.navigationController!.isNavigationBarHidden = false
        self.navigationController!.hidesBarsOnSwipe = true
        
    }
    
    //обновление данных
    func handleRefresh (refreshControl: UIRefreshControl)
    {
        presenter?.refreshData()
    }
    
    //действия при нажатии на кнопку
    func addTapped()
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
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
        imagePicker.delegate = self
    }
    
    func reloadData() -> Void
    {
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
}

//MARK: процедуры DataSource Delegate
extension YADPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return presenter!.getModelsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.kPhotoListCellReuseIdentifier, for: indexPath) as! YADPhotoCollectionViewCell
        
        let model = self.presenter!.getModel(atIndexPath: indexPath as NSIndexPath) as! YADPhotoModel
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let model = presenter?.getSimpleModel!(atIndexPath: indexPath as NSIndexPath) as! YADPhotoModel

        if model.fullSizeURL == ""
        {
            presenter?.itemGetLink!(withModel: model, success: {
                DispatchQueue.main.async {
                    self.browser?.reloadData()
                }
            }, failure: { 
                print("error in selection")
            })
        }
        
        self.setUpAndPresentMWPhB(forModelIndex: indexPath.row)
    }
}

//MARK: реализация процедур MWPhotoBrowserDelegat
extension YADPhotoViewController: MWPhotoBrowserDelegate
{

    func setUpAndPresentMWPhB (forModelIndex modelIndex: Int)
    {
        browser = MWPhotoBrowser(delegate: self)
        browser?.setCurrentPhotoIndex(UInt(modelIndex))
        
        self.navigationController!.pushViewController(browser!, animated: true)
    }
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt
    {
        return UInt(presenter!.getModelsCount())
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol!
    {
        let indexPath = NSIndexPath(row: Int(index), section: 0)
        let model = presenter!.getSimpleModel!(atIndexPath: indexPath) as! YADPhotoModel
        
        //то, что ниже исправить по примеру нажатия
        
        if model.fullSizeURL != ""
        {
            let mwPhoto = MWPhoto(url: URL(string: model.fullSizeURL))
            return mwPhoto
        }
        else
        {
            presenter?.itemGetLink!(withModel: model, success: {
                DispatchQueue.main.async {
                    self.browser?.reloadData()
                }
            }, failure: {
                print("error in selection")
            })
            return MWPhoto()
        }
        
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, actionButtonPressedForPhotoAt index: UInt)
    {
        let indexPath = NSIndexPath(row: Int(index), section: 0)
        
        let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as! YADPhotoCollectionViewCell
        let model = presenter?.getSimpleModel!(atIndexPath: indexPath) as! YADPhotoModel
        
        cell.bigView.sd_setImage(with: NSURL(string: model.fullSizeURL) as! URL)
        
        if let image = cell.bigView.image
        {
            UIImageWriteToSavedPhotosAlbum(image, self , #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image (_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        if let error = error
        {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription , preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        else
        {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your camera roll", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}

//MARK: реализация протоколов UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension YADPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let pickedImageURL = info[UIImagePickerControllerReferenceURL] as? NSURL
        {
            
            let imageReps = PHAsset.fetchAssets(withALAssetURLs: [pickedImageURL as URL], options: nil)
            
            
            let newURL = copyImageForNewURL(withAsset: imageReps[0], path: pickedImageURL)
            
            let prefix = NSDate.timeIntervalSinceReferenceDate
            
            presenter?.uploadPhoto!(WithName: "Image" + String(prefix), url: newURL)
        }
        
       
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func copyImageForNewURL (withAsset asset: PHAsset, path: NSURL) -> String
    {
        let docuPath = try! FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        
        let targetImgeURL = docuPath.appendingPathComponent("IMG_test.jpg")
        
        let phManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        phManager.requestImageData(for: asset, options: options)
        {   imageData,dataUTI,orientation,info in
            
            if let newData: Data = imageData as Data?
            {
                do {
                    
                    print("урл - \(targetImgeURL.absoluteString)")
                    try newData.write(to: targetImgeURL)
                }
                catch let error as NSError {
                    print("\(error)")
                }
            }
        }
        return targetImgeURL.path
    }
}


