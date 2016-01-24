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
    
    /** 朋友圈视图模式 */
    enum Model {
        
        /** 展示 */
        case Show
        
        /** 本地编辑 */
        case LocalEdit
        
        /** 网络数据编辑 */
        case NetworkEdit
    }
    
}


class SinaPhotoView: UIView {
    
    /** interface */
    var model: Model!{didSet{sinaPhotoViewPrepare()}}
    var addBtnClosure:(Void->Void)!
    var deleteBtnClosure:((i: Int, interfaceModel: AnyObject!, photoImageView: PhotoImgView!)->Void)!
    var maxSizeCalOutClosure:(CGSize->Void)!
    var photoModels: [PhotoModel]! {
        get{
            if is_ShowView {return photoModels_private.filter({$0 != nil})}
            
            let imageViews = subviews.filter({$0.isKindOfClass(PhotoImgView)}) as! [PhotoImgView]
            
            return imageViews.map({$0.photoModel})
        }
        set{
            photoModels_private = newValue;
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var clickClosure: ((i: Int, imageView: PhotoImgView!, photoModel: PhotoModel!)->Void)!
    func addPhotoModels(photoModels: [PhotoModel]!){
        photoModels_private = photoModels
        photoModelsDataCommingForShow()
    }
    
    private var is_EditView: Bool {return model != Model.Show}
    private var is_ShowView: Bool {return model == Model.Show}
    
    lazy var margin: CGFloat = 5
    lazy var colCount: CGFloat = 3
    
    var count: Int {return subviews.count}
    lazy var addBtn: UIButton = UIButton(type: UIButtonType.System)
    private var photoModels_private: [PhotoModel] = []
    private var defaultWH: CGFloat = 0
    
    /** 展示图片回调 */
    var setImagesWithClosure:((String!,UIImageView!)->Void)!
    
    /** 是否关闭特殊的4张时的两行模式 */
    var shutOffTwoColModel_Show: Bool = false
}

extension SinaPhotoView {
    
    /** addBtn */
    private func sinaPhotoViewPrepare(){
        
        if is_EditView {
            
            addBtn.tintColor = UIColor.lightGrayColor() ; addBtn.setImage(UIImage(named: "SinaPhotoView.bundle/add"), forState: UIControlState.Normal)
            addBtn.addTarget(self, action: "clickAddBtn", forControlEvents: UIControlEvents.TouchUpInside)
            addSubview(addBtn)
            
        }else{
            
            for (var i=0; i<9; i++){addImageView(is_ShowView: true,photoModel: nil)}
        }
    }
    
    private func photoModelsDataCommingForShow(){
        
        for (var i=0; i<photoModels_private.count; i++){addImageView(is_ShowView: false,photoModel: photoModels_private[i])}
    }
    
    
    
    
    
    /** 点击事件 */
    func clickAddBtn(){addBtnClosure?()}
    
    /** add */
    func addImageView(is_ShowView is_ShowView: Bool = false, photoModel: PhotoModel!){
        
        if photoModels.count >= (is_EditView ? 10 : 9) {return}
        
        let imageView = PhotoImgView();
        imageView.userInteractionEnabled=true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.photoModel = photoModel
        
        if model == Model.LocalEdit {
            imageView.image = photoModel?.img
        }else if model == Model.NetworkEdit {
            setImagesWithClosure?(photoModel?.imgUrl,imageView)
        }
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap:"))
        addSubview(imageView)
        if is_EditView {bringSubviewToFront(addBtn)}
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        if is_EditView {addDeleteBtn(imageView)}else{imageView.hidden = true}
        if (is_EditView) {handleAddBtn(true)};
    }
    
    func tap(tap: UITapGestureRecognizer){
        
        let imageView = tap.view as! PhotoImgView
        
        let i = imageView.index
        
        clickClosure?(i: i, imageView: imageView, photoModel: imageView.photoModel)
    }
    
    func addDeleteBtn(imageView: UIImageView){
        let deleteBtn = UIButton(type: UIButtonType.Custom); deleteBtn.setImage(UIImage(named: "SinaPhotoView.bundle/delete"), forState: UIControlState.Normal)
        deleteBtn.frame = CGRectMake(5, 5, 20, 20)
        deleteBtn.addTarget(self, action: "deleteItemImageView:", forControlEvents: UIControlEvents.TouchUpInside)
        imageView.addSubview(deleteBtn)
    }
    
    func deleteItemImageView(deleteBtn: UIButton){
        
        if is_ShowView {return}
        
        let photoImageV = deleteBtn.superview as! PhotoImgView
        
        if model == Model.LocalEdit {
            
            photoImageV.removeFromSuperview()
        }
        
        handleAddBtn(false)
        
        deleteBtnClosure?(i: photoImageV.index, interfaceModel: photoImageV.photoModel.interfaceModel,photoImageView: photoImageV)
    }
    
    private func handleAddBtn(isAdd: Bool){
        
        let piv = subviews.filter({$0.isKindOfClass(PhotoImgView)})
        
        if piv.count >= 9 {addBtn.removeFromSuperview()} else{insertSubview(addBtn, atIndex: piv.count)}
        
        if !isAdd && count == 9 {insertSubview(addBtn, atIndex: 9)}
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        clipsToBounds = true
        
        if defaultWH == 0 {defaultWH = bounds.size.width}
        
        cal()
        
        if count == 0 {
            self.hidden = true;
            return
        }else{
            self.hidden = false
            assert(model != nil, "Charlin Feng提示您: 请设置isEditView值。")
        }
    }
    
    func cal(){
        
        
        if is_ShowView && photoModels.count == 0 {
            maxSizeCalOutClosure?(CGSizeZero)
        }
        
        
        let totalWH: CGFloat = defaultWH
        
        if is_EditView && count == 1 {
            maxSizeCalOutClosure?(CGSizeMake(CGFloat(Int(totalWH/3)), CGFloat(Int(totalWH/3))));
        }
        
        var wh: CGFloat = (totalWH - (colCount - 1) * margin) / colCount
        var colCount_Cal = colCount
        
        
        if !shutOffTwoColModel_Show && is_ShowView && (photoModels.count == 4) {wh = ((totalWH - margin) / 3).int_float(); colCount_Cal = 2}
        if is_ShowView && (photoModels.count == 1) {wh = (defaultWH / 3).int_float(); colCount_Cal = 1}
        
        
        
        
        for (var i=0; i<count; i++){
            
            weak var subView = subviews[i]
            
            let imageView = subView as? PhotoImgView
            
            imageView?.index = i
            
            let row: CGFloat = CGFloat(Int(CGFloat(i) % colCount_Cal))
            let col: CGFloat = CGFloat(Int(CGFloat(i) / colCount_Cal))
            let x = row * (wh + margin)
            let y = col * (wh + margin)
            let frame = CGRectMake(x, y, wh, wh)
            
            if is_EditView && i == count - 1 && subView!.isKindOfClass(UIButton){
                
                UIView.animateWithDuration(0.1, animations: {
                    subView?.frame = frame}
                )
                
            }else{
                
                subView?.frame = frame
            }
            
            var maxW: CGFloat = CGRectGetMaxX(frame).int_float()
            var maxH: CGFloat = CGRectGetMaxY(frame).int_float()
            
            
            if is_ShowView{
                
                subView?.hidden = true
                
                if i >= count {break}
                
                if photoModels != nil && photoModels.count > 0 {
                    
                    if i < photoModels.count {imageView?.photoModel = photoModels[i] ;setImagesWithClosure?(photoModels[i].imgUrl,imageView)}
                    
                    imageView?.hidden = i > photoModels.count - 1
                    
                    let pc = photoModels.count
                    
                    if i == pc - 1 {
                        
                        maxW = CGFloat(Int(CGRectGetMaxX(subView!.frame)))
                        maxH = CGFloat(Int(CGRectGetMaxY(subView!.frame)))
                        if !shutOffTwoColModel_Show && pc == 4 {maxW = wh * 2 + margin}
                        if pc > 4 && pc <= 6 {maxW = defaultWH}
                        if pc >= 7 && pc <= 9 {maxW = defaultWH}
                        
                        maxSizeCalOutClosure?(CGSizeMake(maxW, maxH))
                    }
                    
                }
                
                
            }else {
                
                let pc = photoModels.count
                if pc >= 3 && pc <= 5 {maxW = defaultWH }
                if pc >= 6 && pc <= 8 {maxW = defaultWH}
                if i == count - 1 && i<10 && i > 0 {maxSizeCalOutClosure?(CGSizeMake(maxW, maxH));}
            }
            
            
        }
    }
    
    
    func removeAllItems_When_NetworkEdit(){
        subviews.forEach({if $0.isKindOfClass(PhotoImgView) {$0.removeFromSuperview()}})
    }
    
}

extension CGFloat {
    
    func int_float()->CGFloat{return CGFloat(Int(self))}
    
}
