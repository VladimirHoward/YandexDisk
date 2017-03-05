//
//  YADPhotoCollectionViewCell.swift
//  YandexDisk
//
//  Created by Gregory House on 26.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit
import SDWebImage

class YADPhotoCollectionViewCell: UICollectionViewCell
{

    @IBOutlet weak var photoView: UIImageView!
    
    
    func configureSelf(photo: YADPhotoModel)
    {
        SDWebImageDownloader.shared().setValue("OAuth " + YADLoginManager.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        photoView.sd_setImage(with: NSURL(string: photo.previewURL) as! URL, placeholderImage: #imageLiteral(resourceName: "placeholder2"))
    }

}
