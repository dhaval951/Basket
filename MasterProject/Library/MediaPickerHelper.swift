//
//  MediaPickerHelper.swift
//  MasterProject
//
//  Created by Sanjay Shah on 04/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

//
//  MediaPicker.swift
//  MasterProject
//
//  Created by Sanjay Shah on 04/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

//MARK: - import Statements
import Foundation
import UIKit
import MobileCoreServices

//MARK: - TypeAlias For CallBack
typealias MediaPickerHelperCallback<inputType> = ((inputType?) -> Void)

//MARK: - MediaPickerHelper Class
class MediaPickerHelper: NSObject {
    
    //MARK: - Variables
    var controller:UIViewController!
    var callbackForImage: MediaPickerHelperCallback<UIImage>?
    var callbackForVideo: MediaPickerHelperCallback<URL>?
    var isForVideo : Bool
    var isAllowEditing : Bool
    
    //MARK: - Variables For Action Title Changes
    var titleForActionSheet : String?
    var titleForCameraButton : String?
    var titleForPhotosButton : String?
    
    //MARK: - init() Method
    init(viewController:UIViewController, isAllowEditing : Bool = true, imageCallback: MediaPickerHelperCallback<UIImage>?) {
        
        self.controller = viewController
        
        //Set call back for image
        self.callbackForImage = imageCallback
        self.isForVideo = false
        self.isAllowEditing = isAllowEditing
        super.init()
        
        showPhotoSourceSelection()
    }
    
    init(viewController:UIViewController, isAllowEditing : Bool = true, videoCallback: MediaPickerHelperCallback<URL>?) {
        
        self.controller = viewController
        
        //Set call back for video
        self.callbackForVideo = videoCallback
        self.isAllowEditing = isAllowEditing
        self.isForVideo = true
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    //MARK: - Show ActionSheet Method
    func showPhotoSourceSelection() {
        let actionSheet = UIAlertController(title: nil, message:self.titleForActionSheet ?? (self.isForVideo ? "Take Video" :"Take image"), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cancelAction)
        
        if (UIImagePickerController.isCameraDeviceAvailable(.rear) ) {
            let cameraAction = UIAlertAction(title: self.titleForCameraButton
                ?? "Camera", style: .default, handler: { (action) -> Void in
                    self.showImagePickerController(sourceType: .camera)
            })
            
            actionSheet.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: self.titleForPhotosButton ?? "Photos", style: .default) { (action) -> Void in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        actionSheet.addAction(photoLibraryAction)
        
        self.controller.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Show ImagePicker Controller
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = self.isAllowEditing
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = self.isForVideo ?  [kUTTypeMovie as String] : [kUTTypeImage as String]
        self.controller.present(imagePickerController, animated: true, completion: nil)
    }
    
}

//MARK: - UIImagePickerController Delegate Extension
extension MediaPickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.controller.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let fixedImaage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
            self.callbackForImage!(fixedImaage)
            
        } else if let videoURL = info[UIImagePickerControllerReferenceURL] as? URL {
            self.callbackForVideo!(videoURL)
            
        }
        
        self.controller.dismiss(animated: true, completion: nil)
    }
}
