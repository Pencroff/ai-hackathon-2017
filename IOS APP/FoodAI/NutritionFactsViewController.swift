//
//  NutritionFactsViewController.swift
//  FoodAI
//
//  Created by Pablo on 2/19/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import UIKit

extension UIView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

class NutritionFactsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var foodLabel: UILabel!
    
    var nutrients = [Nutrient]()
    var image : UIImage?
    var foodName : String?
    
    override func viewDidLoad() {
        imageView.image = image
        foodLabel.text = foodName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutrients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NutritionCell
        let nutrient = nutrients[indexPath.row]
        cell.configure(nutrient: nutrient)
        return cell
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
