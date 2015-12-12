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
        
        //明确指明类型，否则触发断言
        //编辑模式
        editView.isEditView = true
        //展示模式
        showView.isEditView = false

        editView.maxHeightCalOutClosure = {[unowned self] maxH  in
            self.editViewHC.constant = maxH
        }
        
        editView.addBtnClosure = {
           print("请自行完成相册选取控制器的集成")
        }
        
        showView.photoModels = [
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil),
//            SinaPhotoView.PhotoModel(img: nil, interfaceModel: nil)
        ]
        showView.maxHeightCalOutClosure = {[unowned self] maxH  in
            self.showViewHC.constant = maxH
        }
        
        
        editView.tapClosure = {(i,v,m) in
            print(i)
        }
        
        showView.tapClosure = {(i,v,m) in
            print(i)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        print(editView.photoModels.count)
    }


}

