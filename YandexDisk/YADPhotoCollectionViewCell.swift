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
        print("ссылка на fullsize - \(photo.fullSizeURL)")
//        let tempURL = "https://downloader.disk.yandex.ru/preview/7843249fd804ea433928ff75b552b19d7144decfc2eddd3392c5772703cb29d0/inf/oD1hYIypITUP4CGETgjJtp22xnjFaL2yNIjrUOOltN3v1dfQjbvrm0SuA89KUfX1mlZe43XEMLgVxtupj6iHkw%3D%3D?uid=470326164&filename=1280paris_1008.jpg&disposition=inline&hash=&limit=0&content_type=image%2Fjpeg&tknv=v2&size=S&crop=0"
        
//        photoView.sd_setImage(with: NSURL(string: tempURL) as! URL)
        SDWebImageDownloader.shared().setValue("OAuth " + YADLoginManager.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        photoView.sd_setImage(with: NSURL(string: photo.previewURL) as! URL, placeholderImage: #imageLiteral(resourceName: "placeholder2"))
        
    }

}
