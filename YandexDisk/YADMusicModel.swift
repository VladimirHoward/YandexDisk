//
//  YADMusicModel.swift
//  YandexDisk
//
//  Created by Gregory House on 21.03.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation


class YADMusicModel
{
    var resourseID: String
    var name: String
    var path: String
    var audioURL: String
    var created: String
    
    init(withResourseID resourseID: String, name: String, path: String, audioURL: String, created: String)
    {
        self.resourseID = resourseID
        self.name = name
        self.path = path
        self.audioURL = audioURL
        self.created = created
    }
}
