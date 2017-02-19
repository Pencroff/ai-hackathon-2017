//
//  NutritionAPIResponse.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import Foundation
import Gloss

class NutritionAPIResponse : Decodable {
    
    let nutrients: [Nutrient]
    
    required init?(json: JSON) {
        self.nutrients = ("nutrient_list" <~~ json)!
    }
}
