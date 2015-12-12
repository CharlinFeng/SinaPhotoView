//
//  SinaPhotoView.swift
//  SinaPhotoView
//
//  Created by 冯成林 on 15/12/11.
//  Copyright © 2015年 冯成林. All rights reserved.
//

import UIKit

extension SinaPhotoView {
    
    class PhotoModel {
        
        var img: UIImage!
        var imgUrl: String!
        /** 业务模型指针 */
        var interfaceModel: AnyObject!
        init(img: UIImage!, interfaceModel: AnyObject!){self.img = img; self.interfaceModel = interfaceModel}
        init(imgUrl: String!, interfaceModel: AnyObject!){self.imgUrl = imgUrl; self.interfaceModel = interfaceModel}
    }
    
    class PhotoImgView: UIImageView {
        var photoModel: PhotoModel!
        var index: Int = 0
    }
}


class SinaPhotoView: UIView {
    
    /** interface */
    var isEditView: Bool! {didSet{sinaPhotoViewPrepare()}}
    var addBtnClosure:(Void->Void)!
    var maxHeightCalOutClosure:(CGFloat->Void)!
    var photoModels: [PhotoModel]! {
        get{
            if !isEditView! {return photoModels_private.filter({$0 != nil})}
            
            let imageViews = subviews.filter({$0.isKindOfClass(PhotoImgView)}) as! [PhotoImgView]
            
            return imageViews.map({$0.photoModel})
        }
        set{photoModels_private = newValue; }
    }
    var tapClosure: ((i: Int, imageView: PhotoImgView!, photoModel: PhotoModel!)->Void)!
    func addPhotoModels(photoModels: [PhotoModel]!){
        photoModels_private = photoModels
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    lazy var margin: CGFloat = 5
    lazy var colCount: CGFloat = 3
    
    var count: Int {return subviews.count}
    lazy var addBtn: UIButton = UIButton(type: UIButtonType.System)
    private var photoModels_private: [PhotoModel] = []{didSet{photoModelsKVO()}}
}

extension SinaPhotoView {
    
    /** addBtn */
    private func sinaPhotoViewPrepare(){
        
        
        if !isEditView {for (var i=0; i<9; i++){addImageView(true,photoModel: nil)}; return}
        
        addBtn.tintColor = UIColor.lightGrayColor() ; addBtn.setImage(UIImage(named: "SinaPhotoView.bundle/add"), forState: UIControlState.Normal)
        addBtn.addTarget(self, action: "clickAddBtn", forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(addBtn)
    }
    
    private func photoModelsKVO(){
        if isEditView! {return}
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    /** 点击事件 */
    func clickAddBtn(){addBtnClosure?()}
    
    /** add */
    func addImageView(isShowView: Bool = false, photoModel: PhotoModel!){
        
        if photoModels.count >= (isEditView! ? 10 : 9) {return}
        
        if (isEditView!) {handleAddBtn()};
        let imageView = PhotoImgView();
        imageView.userInteractionEnabled=true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.photoModel = photoModel
        imageView.image = photoModel?.img
        if photoModel != nil {photoModels_private.append(photoModel)}
//        imageView.backgroundColor = rgb(0, g: 0, b: 0, a: 0.1)
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap:"))
        addSubview(imageView)
        imageView.clipsToBounds = true
        if isEditView! {addDeleteBtn(imageView)}else{imageView.hidden = true}
    }
    
    func tap(tap: UITapGestureRecognizer){
        
        let imageView = tap.view as! PhotoImgView
        
        let i = imageView.index
        
        print("---------\(photoModels.count): \(i)")
        
        tapClosure?(i: i, imageView: imageView, photoModel: imageView.photoModel)
    }
    
    func addDeleteBtn(imageView: UIImageView){
        let deleteBtn = UIButton(type: UIButtonType.Custom); deleteBtn.setImage(UIImage(named: "SinaPhotoView.bundle/delete"), forState: UIControlState.Normal)
        deleteBtn.frame = CGRectMake(5, 5, 20, 20)
        deleteBtn.addTarget(self, action: "deleteItemImageView:", forControlEvents: UIControlEvents.TouchUpInside)
        imageView.addSubview(deleteBtn)
    }
    
    
    func deleteItemImageView(deleteBtn: UIButton){
        
        let imageView = deleteBtn.superview as! PhotoImgView
        
        deleteBtn.superview?.removeFromSuperview()
        deleteBtn.removeFromSuperview()
        handleAddBtn()
    }
    
    
    
    private func handleAddBtn(){if count==9 {addBtn.removeFromSuperview()} else{insertSubview(addBtn, atIndex: 0)}}
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        assert(isEditView != nil, "Charlin Feng提示您: 请设置isEditView值。")
        
        if count == 0 {self.hidden = true; return}else{self.hidden = false}
        
        cal()
    }
    
    func cal(){
        
        if count == 0 {self.hidden = true; return}else{self.hidden = false}
        
        let totalWH: CGFloat = bounds.size.width
        var wh: CGFloat = (totalWH - (colCount - 1) * margin) / colCount
        var colCount_Cal = colCount
        if !isEditView! && (photoModels.count == 4) {wh = (totalWH - margin) / 2; colCount_Cal = 2}
        if !isEditView! && (photoModels.count == 1) {wh = totalWH; colCount_Cal = 1}
        
        for (var i=0; i<count; i++){
            
            weak var subView = subviews[i]
            
            let imageView = subView as? PhotoImgView
            
            imageView?.index = i
            
            let row: CGFloat = CGFloat(Int(CGFloat(i) % colCount_Cal))
            let col: CGFloat = CGFloat(Int(CGFloat(i) / colCount_Cal))
            let x = row * (wh + margin)
            let y = col * (wh + margin)
            let frame = CGRectMake(x, y, wh, wh)
            
            if isEditView! && i == count - 1 && subView!.isKindOfClass(UIButton){UIView.animateWithDuration(0.1, animations: {subView?.frame = frame})}else{subView?.frame = frame}
            
            var maxH = CGRectGetMaxY(frame)
            
            if !isEditView!{
                
                subView?.hidden = true
                
                if i >= count {break}
                
                if photoModels != nil && photoModels.count > 0 {
                    
                    imageView?.hidden = i > photoModels.count - 1
                    
                    if i == photoModels.count - 1 {maxH = CGRectGetMaxY(subView!.frame);maxHeightCalOutClosure?(maxH)}
                    
//                    if i < photoModels.count {imageView?.imageWithUrl(photoModels[i].imgUrl.resourceURL, placeHolderImage: nil)}
                    
                }
            }
            if !isEditView! && count == 0 && i<10 {maxHeightCalOutClosure?(0)}
            if isEditView! && i == count - 1 && i<10 {maxHeightCalOutClosure?(maxH)}
        }
    }
}
