//
//  ViewController.swift
//  CalHacks2019
//
//  Created by Jonathan Abantao on 10/26/19.
//  Copyright © 2019 Beaver Fever. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    }
    
}

