//
//  ResultsViewController.swift
//  CalHacks2019
//
//  Created by Jonathan Abantao on 10/26/19.
//  Copyright © 2019 Beaver Fever. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var isCorrect = false
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (isCorrect) {
            resultLabel.textColor = UIColor.green
            resultLabel.text = "You did it!"
            textLabel.text = "One of the images you took a picture of matched the word of the day."
        }
        else {
            resultLabel.textColor = UIColor.red
            resultLabel.text = "Sorry"
            textLabel.text = "Unfortunately none of the objects in your photo matched"
        }
        
        scoreLabel.text = "Current score: \(counter)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
