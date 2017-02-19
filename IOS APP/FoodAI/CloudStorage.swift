//
//  CloudManager.swift
//  FoodAI
//
//  Created by Pablo on 2/18/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import Foundation
import Cloudinary


class CloudStorage {
    
    var uploadingProgress : ((Double)->())?
    var finishedUploading : ((_ url: String?, _ error: String?)->())?
    
    private let config : CLDConfiguration!
    private lazy var cloudinary : CLDCloudinary = {
        return CLDCloudinary(configuration: self.config)
    }()
    
    init(cloudName: String, apiKey: String, apiSecret: String) {
        config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
    }
    
    func uploadImage(image: UIImage?,
                     withQuality quality: CGFloat = 0.5,
                     andWidth width: Int = 640,
                     andHeight height: Int = 480) {
        
        guard let image = image,
              let data =  UIImageJPEGRepresentation(image, quality) else {
            return
        }
        
        let params = CLDUploadRequestParams()
        params.setTransformation(
            CLDTransformation()
                .setWidth(width)
                .setHeight(height)
        )
        
        cloudinary
            .createUploader()
            .signedUpload(data: data, params: params, progress:  { progress  in
                self.uploadingProgress?(progress.fractionCompleted)
            }) { (result, error) in
                
                if let error = error {
                    //TODO: Handle Error properly
                    print("*** ERROR: \(error)")
                }
                
                self.finishedUploading?(result?.url, error?.description)
                print("*** Result: \(result)")                
            }
    }
}
