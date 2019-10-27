//
//  ViewController.swift
//  CalHacks2019
//
//  Created by Jonathan Abantao on 10/26/19.
//  Copyright © 2019 Beaver Fever. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker: UIImagePickerController!
    var count: Int = 0
    var goodPicture: Bool = false
    let words = ["Cat", "Dog", "Hat"]

    @IBOutlet weak var wordOfTheDayLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        
        view.layer.insertSublayer(layer, at: 0)
        
        
        if let randomWord = words.randomElement() {
            wordOfTheDayLabel.text = randomWord
        }
    }

    @IBAction func takePhoto(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        
        sendImageToAPI()
    }
    
    func sendImageToAPI() {
        
        // Create VisionImage
        let image = VisionImage(image: (imageView.image)!)
        
        let options = VisionCloudImageLabelerOptions()
        options.confidenceThreshold = 0.7
        let labeler = Vision.vision().cloudImageLabeler(options: options)
        
        // Send to API & get information
        labeler.process(image) { labels, error in
            guard error == nil, let labels = labels else { return }

            print("*************Sent to API***************")
            // Task succeeded.
            for label in labels {
                let labelText = label.text
                let entityId = label.entityID
                let confidence = label.confidence
                
                print("label text: \(labelText)")
                print("entity id: \(String(describing: entityId))")
                print("confidence: \(String(describing: confidence))")
                
                if label.text == self.wordOfTheDayLabel.text {
                    //increment count
                    self.count = self.count + 1
                    // set boolean flag
                    self.goodPicture = true
                    self.performSegue(withIdentifier: "ResultsSegue", sender: self)
                    
                }
            
            }
            // no match sorry :(
            self.goodPicture = false
            self.performSegue(withIdentifier: "ResultsSegue", sender: self)
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultsViewController
        vc.isCorrect = self.goodPicture
        vc.counter = self.count
    }
    
    
    
}

