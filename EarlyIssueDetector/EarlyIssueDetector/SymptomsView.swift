//
//  ViewController.swift
//  EarlyIssueDetector
//
//  Created by Andrew Rotert on 10/27/20.
//

import UIKit

class SymptomsView: UIViewController {
    
    @IBOutlet weak var TextBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Finishes setup on ARSKView
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        ViewController.HealthSymptoms = TextBox.text
        ViewController.this.resumeAR()
    }
    
}
