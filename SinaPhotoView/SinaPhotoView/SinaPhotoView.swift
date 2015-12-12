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
    }
}


class SinaPhotoView: UIView {
    
    /** interface */
    var isEditView: Bool! {didSet{sinaPhotoViewPrepare()}}
    var addBtnClosure:(Void->Void)!
    var maxHeightCalOutClosure:(CGFloat->Void)!
    var photoModels: [PhotoModel]! {
        get{return photoModels_private.filter({$0 != nil})}
        set{photoModels_private = newValue; }
    }
    var tapClosure: ((i: Int, imageView: PhotoImgView!, photoModel: PhotoModel!)->Void)!
    func addPhotoModels(photoModels: [PhotoModel]!){
        photoModels_private.removeAll()
        for (_,pm) in photoModels.enumerate(){if photoModels.count >= 9 {return} ;addImageView(false, photoModel: pm)}
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
        
        if photoModels.count >= 9 {return}
        
        if (isEditView!) {handleAddBtn()};
        let imageView = PhotoImgView();
        imageView.userInteractionEnabled=true
        imageView.photoModel = photoModel
        imageView.image = photoModel?.img
        if photoModel != nil {photoModels_private.append(photoModel)}
        if !isEditView! {}
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap:"))
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.redColor()
        
        if isEditView! {addDeleteBtn(imageView)}else{imageView.hidden = true}
    }
    
    func tap(tap: UITapGestureRecognizer){
        let imageView = tap.view as! PhotoImgView
        
        tapClosure?(i: imageView.tag, imageView: imageView, photoModel: imageView.photoModel)
    }
    
    func addDeleteBtn(imageView: UIImageView){
        let deleteBtn = UIButton(type: UIButtonType.System);deleteBtn.tintColor = UIColor.lightGrayColor() ; deleteBtn.setImage(UIImage(named: "SinaPhotoView.bundle/delete"), forState: UIControlState.Normal)
        deleteBtn.frame = CGRectMake(5, 5, 20, 20)
        deleteBtn.addTarget(self, action: "deleteItemImageView:", forControlEvents: UIControlEvents.TouchUpInside)
        imageView.addSubview(deleteBtn)
    }
    
    
    func deleteItemImageView(deleteBtn: UIButton){
        
        let imageView = deleteBtn.superview as! PhotoImgView
        let index = photoModels_private.indexOf({$0 === imageView.photoModel})
        let i = Int(index!)
        photoModels_private.removeAtIndex(i)
        deleteBtn.superview?.removeFromSuperview()
        deleteBtn.removeFromSuperview()
        handleAddBtn()
    }
    
    
    
    private func handleAddBtn(){if count==9 {addBtn.removeFromSuperview()} else{insertSubview(addBtn, atIndex: 0)}}
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        assert(isEditView != nil, "Charlin Feng提示您: 请设置isEditView值。")
        let totalWH: CGFloat = bounds.size.width
        var wh: CGFloat = (totalWH - (colCount - 1) * margin) / colCount
        var colCount_Cal = colCount
        if !isEditView! && (photoModels.count == 4) {wh = (totalWH - margin) / 2; colCount_Cal = 2}
        if !isEditView! && (photoModels.count == 1) {wh = totalWH; colCount_Cal = 1}
        for (var i=0; i<count; i++){
            
            weak var subView = subviews.reverse()[i]
            
            subView?.tag = i
            let row: CGFloat = CGFloat(Int(CGFloat(i) % colCount_Cal))
            let col: CGFloat = CGFloat(Int(CGFloat(i) / colCount_Cal))
            let x = row * (wh + margin)
            let y = col * (wh + margin)
            let frame = CGRectMake(x, y, wh, wh)
            if i == count - 1 && subView!.isKindOfClass(UIButton){UIView.animateWithDuration(0.1, animations: {subView?.frame = frame})}else{subView?.frame = frame}
            var maxH = CGRectGetMaxY(frame)
            
            if !isEditView!{
                subView?.hidden = true
                if photoModels != nil && photoModels.count > 0 {
                    
                    subView!.hidden = i > photoModels.count - 1
                    if i == photoModels.count - 1 {maxH = CGRectGetMaxY(subView!.frame);maxHeightCalOutClosure?(maxH)}
                }else{
                    subView?.hidden = true
                }
                subView!.contentMode = photoModels.count == 1 ? UIViewContentMode.ScaleAspectFit : UIViewContentMode.ScaleAspectFill
            }
            if !isEditView! && count == 0 && i<10 {maxHeightCalOutClosure?(0)}
            if isEditView! && i == count - 1 && i<10 {maxHeightCalOutClosure?(maxH)}
        }
    }
}
