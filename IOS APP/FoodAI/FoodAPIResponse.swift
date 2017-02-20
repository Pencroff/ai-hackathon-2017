//
//  FoodAPIResponse.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import Foundation
import Gloss

class FoodAPIResponse : Decodable {
    
    let code: Int
    let needCheck: Bool
    let status: String
    let qid: Int
    let tags: [String:Double]
    lazy var foodName : String! = { [unowned self] in
        if let first = self.tags.first {
            return first.key
        }
        return "Not Food :("
    }()
    
    required init?(json: JSON) {
        self.code = ("code" <~~ json)!
        
        self.status = ("status" <~~ json)!
        self.qid = ("qid" <~~ json)!
        let needCheck = ("need_check" <~~ json)! == "true"
        self.needCheck = needCheck
        
        var tags = [String:Double]()
        let tagsArrays : [[String]] = ("tags" <~~ json)!
        tagsArrays.forEach { (array) in
            if array.count == 2 {
                if let value = Double(array[1]),
                       value > 0.0 {
                    tags[array[0]] = value
                }
            }
        }
        self.tags = tags
    }
}
