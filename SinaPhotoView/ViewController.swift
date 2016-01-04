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
        

        editViewPrepare()

        showViewPrepare()

    }
    
    
    
    func editViewPrepare(){
        
     editView.isEditView = true
        
        editView.maxSizeCalOutClosure = {[unowned self] size  in
  
            self.editViewWC.constant = size.width
            self.editViewHC.constant = size.height
        }

        editView.addBtnClosure = {
            self.editView.addPhotoModels([SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)])
            self.showView.photoModels = self.editView.photoModels
        }
        
        editView.deleteBtnClosure = {
            self.showView.photoModels = self.editView.photoModels
        }
        
        editView.tapClosure = {(i,v,m) in
         
        }
    }
    
    
    

    
    
    
    
    
    func showViewPrepare(){
        
        //展示模式
        showView.isEditView = false
        
        showView.photoModels = [
            
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)
        ]
        
        showView.maxSizeCalOutClosure = {[unowned self] size  in
            print(size)
            self.showViewWC.constant = size.width
            self.showViewHC.constant = size.height
        }
        
        
        showView.tapClosure = {(i,v,m) in
     
        }
    }
}

