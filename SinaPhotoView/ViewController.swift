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
    
    @IBOutlet weak var editViewWC: NSLayoutConstraint!
    @IBOutlet weak var editViewHC: NSLayoutConstraint!
    
    
    @IBOutlet weak var showView: SinaPhotoView!
    
    @IBOutlet weak var showViewWC: NSLayoutConstraint!
    @IBOutlet weak var showViewHC: NSLayoutConstraint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//
        editViewPrepare()
//
        showViewPrepare()

    }
    
    
    
    func editViewPrepare(){
        
        editView.layer.borderColor = UIColor(white: 0.4, alpha: 0.2).CGColor
        editView.layer.borderWidth = 0.5
        
        //展示模式
        editView.model = SinaPhotoView.Model.LocalEdit
        
        editView.maxSizeCalOutClosure = {[unowned self] size  in
  
            self.editViewWC.constant = size.width
            self.editViewHC.constant = size.height
        }

        editView.addBtnClosure = {
            self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
            self.showView.photoModels = self.editView.photoModels
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
                self.showView.photoModels = self.editView.photoModels
            })
        }
        
    }

    
    

    
    
    
    
    
    func showViewPrepare(){
        
        //展示模式
        showView.model = SinaPhotoView.Model.Show
        
        showView.photoModels = [
            
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)
        ]
        
        showView.maxSizeCalOutClosure = {[unowned self] size  in
            print(size)
            self.showViewWC.constant = size.width
            self.showViewHC.constant = size.height
        }
    }
}

