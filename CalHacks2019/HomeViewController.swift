//
//  ViewController.swift
//  CalHacks2019
//
//  Created by Jonathan Abantao on 10/26/19.
//  Copyright © 2019 Beaver Fever. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class HomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker: UIImagePickerController!
    var count = 0
    var goodPicture: Bool = false
    let wordsAndImages = [
        "Cat": "https://i.imgur.com/t6bMWca.jpg",
        "Dog": "https://i.imgur.com/o8v5fF0.jpg",
        "Hat": "https://i.imgur.com/LOaPUPI.jpg",
        "Plant": "https://i.imgur.com/jY8r55C.jpg",
    ]
    var savedWord = ""
    var savedImage: UIImage!
    var spinnerView: UIViewController?

    @IBOutlet weak var wordOfTheDayLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var score: UILabel!
 
    override func loadView() {
        super.loadView()
        
        if let savedWord = UserDefaults.standard.string(forKey: "word") {
            self.savedWord = savedWord
        }
        else {
            if let (randomWord, _) = wordsAndImages.randomElement() {
                self.savedWord = randomWord
                UserDefaults.standard.set(randomWord, forKey: "word")
            }
        }
        self.count = UserDefaults.standard.integer(forKey: "count")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        
        view.layer.insertSublayer(layer, at: 0)
        
        imageView.layer.cornerRadius = imageView.frame.size.height * (1 / 8)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        
        updateLabels()
    }

    @IBAction func takePhoto(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
        createSpinnerView()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.savedImage = info[.originalImage] as? UIImage
        
        sendImageToAPI()
    }
    
    func sendImageToAPI() {
                // Create VisionImage
        let image = VisionImage(image: (self.savedImage)!)
        
        let options = VisionCloudImageLabelerOptions()
        options.confidenceThreshold = 0.7
        let labeler = Vision.vision().cloudImageLabeler(options: options)
        
        // Send to API & get information
        labeler.process(image) { labels, error in
            guard error == nil, let labels = labels else { return }

            print("*************Sent to API***************")
            self.removeSpinnerView()
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
                    UserDefaults.standard.set(self.count, forKey:"count")
                    
                    self.score.text = "Score: \(self.count)"
                    // set boolean flag
                    self.goodPicture = true
                    self.performSegue(withIdentifier: "ResultsSegue", sender: self)
                        print("called after segue success")
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
        vc.picture = self.savedImage
    }
    
    @IBAction func resetGame(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "word")
        UserDefaults.standard.removeObject(forKey: "count")
        
        count = 0
        savedWord = ""

        if let(randomWord, _) = wordsAndImages.randomElement() {
            self.savedWord = randomWord
            UserDefaults.standard.set(randomWord, forKey:"word")
        }
        
        updateLabels()
     }
    
    private func updateLabels() {
        let wordURL = wordsAndImages[self.savedWord]!
        let imageURL = URL(string: wordURL)!
        
        self.wordOfTheDayLabel.text = savedWord
        self.score.text = "Score: \(self.count)"
        self.imageView.af_setImage(withURL: imageURL)
    }
    
    private func createSpinnerView() {
        let child = SpinnerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        self.spinnerView = child
    }
    
    private func removeSpinnerView() {
        if self.spinnerView != nil {
            let child = self.spinnerView!
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}

