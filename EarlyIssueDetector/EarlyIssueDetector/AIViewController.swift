//
//  ViewController.swift
//  EarlyIssueDetector
//
//  Created by Andrew Rotert on 10/27/20.
//

import UIKit

class AIViewController: UIViewController {

    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var AppointmentButton: UIButton!
    
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
        }
    }
    @IBAction func AppointmentClicked(_ sender: Any) {
        let myUrl = "https://www.sanfordhealth.org/locations"
           if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
    }
    
}
