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
    let words = ["Cat", "Dog", "Hat"]

    @IBOutlet weak var wordOfTheDayLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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
        
        let options = VisionOnDeviceImageLabelerOptions()
        options.confidenceThreshold = 0.7
        let labeler = Vision.vision().onDeviceImageLabeler(options: options)
        
        // Send to API & get information
        labeler.process(image) { labels, error in
            guard error == nil, let labels = labels else { return }

            print("Sent to API")
            // Task succeeded.
            for label in labels {
                let labelText = label.text
                let entityId = label.entityID
                let confidence = label.confidence
                
                print("label text: \(labelText)")
                print("entity id: \(String(describing: entityId))")
                print("confidence: \(String(describing: confidence))")
            
            }
        }
        
        
    }
    
}

