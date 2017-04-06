//
//  YADMusicTableViewCell.swift
//  YandexDisk
//
//  Created by Gregory House on 21.03.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit

class YADMusicTableViewCell: UITableViewCell
{

   
    @IBOutlet weak var musicIcon: UIImageView!
    
    @IBOutlet weak var songName: UILabel!
    
    func configureSelf (withModel model: YADMusicModel)
    {
        songName.text = model.name
    }
}
