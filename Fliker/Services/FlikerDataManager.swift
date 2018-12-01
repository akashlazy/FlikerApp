//
//  FlikerDataManager.swift
//  Fliker
//
//  Created by Dolphin on 01/12/18.
//  Copyright © 2018 World. All rights reserved.
//

import Foundation

class FlikerDataManager {
    
    static let sharedInstance = FlikerDataManager()
    
    struct Errors {
        static let InvalidAccessErrorCode = 100
    }
    
    struct FlikerMetadataKeys {
        static let failureStatusCode = "Code"
    }
    
    struct FlikerAPI {
        static let APIKey = ""
        
        static let tagsSearchFormat =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&pages=%i&format=json&nojsoncallback=1"
    }
    
    func fetchPhotoFor(searchText: String, page: Int, clousure: @escaping (NSError?, NSInteger, [FlikerPhotoModel]?) -> Void) -> Void {
        
        let espacedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let format = FlikerAPI.tagsSearchFormat
        let arguments: [CVarArg] = [FlikerAPI.APIKey, espacedSearchText!, page]
        
        let photoUrl = String(format: format, arguments)
        
        let url = NSURL(string: photoUrl)!
        let request = URLRequest(url: url as URL)
        
        let searchTask = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if error != nil {
                print("Error photo: ", error)
                clousure(error as NSError?, 0, nil)
            }
            
            do {
                let resultDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard let results = resultDict else { return }
                
                if let statusCode = results[FlikerMetadataKeys.failureStatusCode] as? Int {
                    if statusCode == Errors.InvalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "FlikerAPIDomain", code: statusCode, userInfo: nil)
                        clousure(invalidAccessError, 0, nil)
                        return
                    }
                }
                
                guard let photosContainer = resultDict!["photos"] as? NSDictionary else { return }
                guard let totalPageCountString = photosContainer["total"] as? String else { return }
                guard let totalPageCount = NSInteger(totalPageCountString as! String) else { return }
                
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                
                let flikerPhotos: [FlikerPhotoModel] = photosArray.map({ (photoDict) -> FlikerPhotoModel in
                    
                    let photoID = photoDict["id"] as? String ?? ""
                    let farm = photoDict["farm"] as? Int ?? 0
                    let secret = photoDict["secret"] as? String ?? ""
                    let server = photoDict["server"] as? String ?? ""
                    let title = photoDict["title"] as? String ?? ""
                    
                    let flikerPhoto = FlikerPhotoModel(photoID: photoID, farm: farm, secret: secret, server: server, title: title)
                    
                    return flikerPhoto
                })
                
                clousure(nil, totalPageCount, flikerPhotos)
                
            } catch let error as NSError {
                print("Error parsing Error: ", error)
            }
        }
    }
}
