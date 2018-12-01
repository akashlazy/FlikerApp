//
//  PhotoViewController.swift
//  Fliker
//
//  Created by Dolphin on 01/12/18.
//  Copyright © 2018 World. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FlikerDataManager.sharedInstance.fetchPhotoFor(searchText: photoSearchKey, page: 1) { (error, page, photos) in
            print(photos)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
