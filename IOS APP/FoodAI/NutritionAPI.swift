//
//  NutritionAPI.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Gloss

class NutritionAPI {
    
    private let apiUrl = "https://ai-hackathon-2017.herokuapp.com/"
    
    var didFinishGettingNutritionFacts : (([Nutrient], String)->())?
    var startedGettingNutritionFacts : (()->())?
    
    func getNutritionFacts(of foodName: String) {
        
        guard let encodedFoodName = foodName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        startedGettingNutritionFacts?()
        
        Alamofire
            .request("\(apiUrl)compare/\(encodedFoodName)")
            .responseObject(NutritionAPIResponse.self)
            { response in
                switch response.result {
                case .success(let nutritionFacts):
                    self.didFinishGettingNutritionFacts?(nutritionFacts.nutrients, foodName)
                case .failure(let error):
                    self.didFinishGettingNutritionFacts?([Nutrient](), foodName)
                    print(error.localizedDescription)
                }
        }
    }
}
