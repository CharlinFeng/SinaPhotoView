
![image](https://github.com/CharlinFeng/Resource/blob/master/SinaPhotoView/logo.png)<br />

<br/><br/><br/>
朋友圈相册视图（edit、show）
===============
<br/>

.Swift 2<br/><br/>
.Xcode 7


<br/><br/><br/> 
框架说明
===============

>. 一个Swift文件快速集成类似新浪微博，微信朋友圈相册添加、编辑、展示视图。<br/> 
>. 支持Xib，支持纯代码。支持autoLayout。<br/> 
>. 动态高度回调。<br/> 
>. 针对tableview以及collectionView做了大量性能优化。<br/> 
>. 支持事件回调。<br/> 

<br/> <br/> 
#### 注：请直接拖拽SinaPhotoView文件夹到你的项目即可，不支持pod。
####  请注意照片为1，4，其他数量时的展示方式以及对应的sinaPhotoView的整体的高度变化。
<br/> <br/> 

![image](https://github.com/CharlinFeng/Resource/blob/master/SinaPhotoView/1.gif)<br />


<br/><br/><br/> 
使用说明
===============
<br/><br/>
####1.导入
直接拖拽SinaPhotoView文件夹到您项目中直接当做普通view使用。

        //明确指明类型，否则触发断言
        //编辑模式
        editView.isEditView = true
        //展示模式
        showView.isEditView = false
        
        
<br/><br/>

####2. 获取动态高度回调，更新约束
        editView.maxHeightCalOutClosure = {[unowned self] maxH  in
            self.editViewHC.constant = maxH
        }
        

<br/><br/>
#### 3. 编辑模式下，点击添加按钮，请在closure中返回图片数据：请执行您的相册选取操作
注：interfaceModel 为app项目模型指针，比如你有自己的模式，可直接填入，后期回调将非常容易获取数据。

        editView.addBtnClosure = {
           
        }
        
        
#### 4. 批量添加图片数据：

        mgr.finishPickingMedia = { [unowned self] medias in
            
            let photoModels = medias.map({SinaPhotoView.PhotoModel(img: $0.editedImage, interfaceModel: nil)})
            
            //批量添加
            self.photoView.addPhotoModels(photoModels)
        }
        



<br/><br/>
#### 5. 点击图片事件回调：请执行您的照片浏览器展示操作
        showView.tapClosure = {(i,v,m) in
            print(i)
        }
        
  
<br/><br/>
#### 5. 当前相册视图添加或者展示的所有模型，请通过以下计算属性获取：

     var photoModels: [PhotoModel]!
     
