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
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var scrimView: UIView!
    
    var bigView = UIImageView()
    
    var gradientLayer : CAGradientLayer?
    
    func configureSelf(photo: YADPhotoModel)
    {
        SDWebImageDownloader.shared().setValue("OAuth " + YADLoginManager.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        
        photoView.sd_setImage(with: NSURL(string: photo.previewURL) as! URL, placeholderImage: #imageLiteral(resourceName: "placeholder2"))
        
        testLabel.text = photo.name
        
        if (gradientLayer == nil)
        {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            let layer = CAGradientLayer()
            layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            layer.frame = CGRect(x: 0.0, y: 0.0, width: scrimView.frame.width, height: scrimView.frame.height)
            
            scrimView.layer.addSublayer(layer)
            gradientLayer = layer
        }
    }
}
