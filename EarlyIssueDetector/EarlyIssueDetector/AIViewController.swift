//
//  ViewController.swift
//  EarlyIssueDetector
//
//  Created by Andrew Rotert on 10/27/20.
//

import UIKit

class AIViewController: UIViewController {
    
    let defaultText = "Enter your symptoms separated by a comma"
    
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var AppointmentButton: UIButton!
    @IBOutlet weak var SymptomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Finishes setup on ARSKView
        super.viewDidAppear(animated)
        if(ViewController.HealthImage != nil)
        {
            MainImage.image = ViewController.HealthImage
            MainImage.contentMode = .scaleAspectFill
            if(ViewController.HealthSymptoms != nil && ViewController.HealthSymptoms != defaultText){
                SymptomLabel.text = ViewController.HealthSymptoms.replacingOccurrences(of: ",", with: "\n")
            }
        }
    }
    @IBAction func AppointmentClicked(_ sender: Any) {
        let myUrl = "https://www.sanfordhealth.org/locations"
           if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
    }
    override func viewDidDisappear(_ animated: Bool) {
        ViewController.this.resumeAR()
    }
    
}
