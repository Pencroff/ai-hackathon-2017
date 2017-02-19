//
//  FoodAPI.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Gloss

class FoodAPI {
    
    private let apiUrl = "http://api.foodai.org/v1/"
    
    var foodDescribed : ((_ foodName: String?, _ error: String?)->())?
    
    func describeFood(url: String) {
        
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        Alamofire
            .request("\(apiUrl)classify?image_url=\(encodedUrl)")
            .responseObject(FoodAPIResponse.self) { response in
                switch response.result {
                case .success(let food):
                    self.foodDescribed?(food.foodName, nil)
                case .failure(let error):
                    self.foodDescribed?(nil, error.localizedDescription)
                }
            }
    }
}
