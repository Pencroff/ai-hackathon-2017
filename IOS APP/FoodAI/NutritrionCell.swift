//
//  NutritrionCell.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import UIKit

class NutritionCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    func configure(nutrient: Nutrient) {
        self.name.text = nutrient.name.capitalized
        self.value.text = "\(nutrient.value)\(nutrient.unit)"
    }
}
