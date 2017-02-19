//
//  ViewController.swift
//  FoodAI
//
//  Created by Pablo on 2/18/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import UIKit
import SwiftSpinner




class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FoodAIDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    private var image : UIImage? {
        didSet {
            imageView.image = image
        }
    }
    private var nutrients = [Nutrient]()
    private var foodName : String?
    
    private var hasLaunchedCamera = false
    private let segueName = "showNutrients"
    
    private lazy var imagePicker : UIImagePickerController! = {
        [unowned self] in
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        return imagePicker
    }()

    private lazy var foodAI : FoodAI! = {
        let foodAI = FoodAI(cloudStorageCloudName: Settings.cloudName,
                            cloudStorageApiKey: Settings.apiKey,
                            cloudStorageApiSecret: Settings.apiSecret)
        foodAI.delegate = self
        
        foodAI.uploadingProgress = { progress in
            SwiftSpinner.show(progress: progress, title: "Uploading \(Int(progress * 100))%")
        }
        
        foodAI.finishedUploading = { url in
            SwiftSpinner.show("Processing", animated: true)
        }
        
        foodAI.onError = { error in
            SwiftSpinner.show(duration: 2, title: "Error. Please try again")
        }
        
        return foodAI
    }()
    
    override func viewDidLoad() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if hasLaunchedCamera == false {
            takePicture()
        }
    }
    
    func showNutrients() {
        self.performSegue(withIdentifier: segueName, sender: self)
    }
    
    func tap() {
        if image == nil {
            takePicture()
            return
        }
        if nutrients.count > 0 {
            showNutrients()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.image = image
        if let image = image {
            foodAI.getNutritionFacts(forImage: image)
        }
    }

    @IBAction func takePicture() {
        present(imagePicker, animated: true, completion: nil)
        hasLaunchedCamera = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueName {
            let vc = segue.destination as! NutritionFactsViewController
            vc.nutrients = nutrients
            vc.image = image
            vc.foodName = foodName
        }
    }
    
    func foodAI(_ foodAI: FoodAI, didRecognizeFood food: String) {
        SwiftSpinner.show(food, animated: true)
    }
    
    func foodAI(_ foodAI: FoodAI, didGetNutrionFacts nutritionFacts: [Nutrient], forFood food: String) {
        self.nutrients = nutritionFacts
        self.foodName = food
        if nutritionFacts.count > 0 {
            SwiftSpinner.hide()
            showNutrients()
        } else {
            SwiftSpinner.show(duration: 3, title: "Please try again", animated: true)
        }
    }
}

