//
//  Nutrient.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import Foundation
import Gloss

class Nutrient : Decodable {
    
    let name: String
    let unit: String
    let value: Double
    
    required init?(json: JSON) {
        self.name = ("name" <~~ json)!
        self.unit = ("unit" <~~ json)!
        let valueString : String = ("value" <~~ json)!
        self.value = Double(valueString) ?? 0.0
    }
}
