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
    @IBOutlet weak var text: UILabel!
    
    func configureSelf(photo: YADPhotoModel)
    {
        print("ссылка на превью в клетке - \(photo.previewURL)")
//        let tempURL = "https://pp.vk.me/c615722/v615722650/15f4b/FhsTV4cLHGI.jpg"
//        photoView.sd_setImage(with: NSURL(string: tempURL) as! URL)
        photoView.sd_setImage(with: NSURL(string: photo.previewURL) as! URL, placeholderImage: #imageLiteral(resourceName: "placeholder2"))
        text.text = photo.name
        
    }

}
