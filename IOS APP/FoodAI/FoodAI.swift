//
//  FoodAI.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import UIKit

protocol FoodAIDelegate {
    func foodAI(_ foodAI: FoodAI, didRecognizeFood food: String)
    func foodAI(_ foodAI: FoodAI, didGetNutrionFacts nutritionFacts: [Nutrient], forFood food: String)
}

class FoodAI {
    
    var foodName : String?
    var nutrients : [Nutrient]?
    var delegate : FoodAIDelegate?
    var uploadingProgress : ((Double)->())?
    var finishedUploading : ((String)->())?
    var onError : ((String)->())?
    
    let cloudName : String!
    let apiKey : String!
    let apiSecret : String!
    
    
    private var foodRecognizer = FoodAPI()
    private var nutritionAPI = NutritionAPI()
    private lazy var cloudStorage : CloudStorage! = {
        
        let cloudStorage = CloudStorage(
            cloudName: self.cloudName,
            apiKey: self.apiKey,
            apiSecret: self.apiSecret
        )
        
        cloudStorage.uploadingProgress = { progress in
            print("Progress = \(progress)")
            self.uploadingProgress?(progress)
        }
        
        self.foodRecognizer.foodDescribed = { (foodName, error) in
            self.foodName = foodName
            if let foodName = foodName {
                self.delegate?.foodAI(self, didRecognizeFood: foodName)
                self.nutritionAPI.getNutritionFacts(of: foodName)
            } else if let error = error {
                //TODO: Handle Error
                self.onError?(error)
            }
        }
        
        cloudStorage.finishedUploading = { (url, error) in
            if let url = url {
                self.finishedUploading?(url)
                self.foodRecognizer.describeFood(url: url)
            } else if let error = error {
                self.onError?(error)
            }
        }
        
        self.nutritionAPI.didFinishGettingNutritionFacts = { (nutrients, food) in
            print("nutritionFacts : \(nutrients)")
            self.nutrients = nutrients
            self.delegate?.foodAI(self, didGetNutrionFacts: nutrients, forFood: food)
        }
        return cloudStorage
    }()
    
    
    init(cloudStorageCloudName cloudName: String, cloudStorageApiKey apiKey: String, cloudStorageApiSecret apiSecret: String) {
        self.cloudName = cloudName
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    func getNutritionFacts(forImage image: UIImage) {
        cloudStorage.uploadImage(image: image)
    }
}
