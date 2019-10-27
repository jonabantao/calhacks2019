//
//  ResultsViewController.swift
//  CalHacks2019
//
//  Created by Jonathan Abantao on 10/26/19.
//  Copyright © 2019 Beaver Fever. All rights reserved.
//

import UIKit
import AVFoundation

class ResultsViewController: UIViewController, AVAudioPlayerDelegate {
    var audioPlayer : AVAudioPlayer!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pictureTaken: UIImageView!
    var isCorrect = false
    var counter = 0
    var picture: UIImage!
    
    let soundArray = ["success", "wompwomp"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isCorrect) {
            setupSuccessModal()
            playSound(soundFileName : soundArray[0])
        }
        else {
            setupFailureModal()
            playSound(soundFileName : soundArray[1])
        }
        scoreLabel.text = "Current score: \(counter)"
        pictureTaken.image = picture
    }
    
    private func setupSuccessModal() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor]
        
        view.layer.insertSublayer(layer, at: 0)
        resultLabel.text = "You did it!"
        textLabel.text = "One of the images you took a picture of matched the word of the day."
    }
    
    private func setupFailureModal() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.systemRed.cgColor, UIColor.systemPink.cgColor]
        
        view.layer.insertSublayer(layer, at: 0)
        
        resultLabel.text = "Sorry"
        textLabel.text = "Unfortunately none of the objects in your photo matched"
    }
    
    func playSound(soundFileName : String) {
        let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        
        audioPlayer.play()
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
