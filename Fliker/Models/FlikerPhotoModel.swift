//
//  FlikerPhotoModel.swift
//  Fliker
//
//  Created by Dolphin on 01/12/18.
//  Copyright © 2018 World. All rights reserved.
//

import Foundation

struct FlikerPhotoModel {
    let photoID: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoURL: NSURL {
        return flikerImageURL()
    }
    
    var largePhotoURL: NSURL {
        return flikerImageURL(size: "b")
    }
    
    func flikerImageURL(size: String = "m") -> NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")!
    }
}
