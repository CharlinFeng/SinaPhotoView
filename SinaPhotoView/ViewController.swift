//
//  ViewController.swift
//  SinaPhotoView
//
//  Created by 冯成林 on 15/12/11.
//  Copyright © 2015年 冯成林. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var editView: SinaPhotoView!
    @IBOutlet weak var editViewHC: NSLayoutConstraint!
    
    
    @IBOutlet weak var showView: SinaPhotoView!
    @IBOutlet weak var showViewHC: NSLayoutConstraint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editView.isEditView = true
        showView.isEditView = false

        editView.maxHeightCalOutClosure = {[unowned self] maxH  in
            self.editViewHC.constant = maxH
        }
        
        editView.addBtnClosure = {
            print("ok")
            return SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)
        }
        
        showView.photoModels = [
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)
        ]
        showView.maxHeightCalOutClosure = {[unowned self] maxH  in
            self.showViewHC.constant = maxH
        }
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        print(editView.photoModels.count)
    }


}

