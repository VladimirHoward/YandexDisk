//
//  YADVideoCollectionViewCell.swift
//  YandexDisk
//
//  Created by Admin on 26.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit

class YADVideoCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var videoView: UIImageView!

    func configureSelf(video: YADVideoModel)
    {
        print("ссылка на превью в клетке - \(video.previewURL)")
        videoView.sd_setImage(with: NSURL(string: video.previewURL) as! URL, placeholderImage: #imageLiteral(resourceName: "video_view"))
        
    }

}