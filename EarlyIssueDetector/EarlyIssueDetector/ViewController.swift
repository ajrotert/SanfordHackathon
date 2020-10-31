//
//  ViewController.swift
//  EarlyIssueDetector
//
//  Created by Andrew Rotert on 10/27/20.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneAR: ARSCNView!
    @IBOutlet weak var ScreenShotButton: UIButton!
    @IBOutlet weak var Symptoms: UIButton!
    @IBOutlet weak var ConnectMedicalRecords: UIButton!
    @IBOutlet weak var PausePlayButton: UIButton!
    
    static var HealthImage: UIImage!
    static var this: ViewController!
    static var HealthSymptoms: String!
    
    var counter = 0
    
    let coachingOverlay = ARCoachingOverlayView()

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.this = self
        setupCoachingOverlay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Finishes setup on ARSKView
        super.viewDidAppear(animated)
        setupConfiguration()
    }

    func setupConfiguration() {
        //Defines what ARSCView tracks
        let configuration = ARObjectScanningConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        sceneAR.automaticallyUpdatesLighting = false
        sceneAR.delegate = self
        sceneAR.session.run(configuration,  options: .resetTracking)
        sceneAR.debugOptions = [.showBoundingBoxes, .showConstraints, .showCreases, .showFeaturePoints, .showPhysicsFields, .showPhysicsShapes]
    }
    @IBAction func Symptoms_Clicked(_ sender: Any) {
        sceneAR.pause(nil)
    }
    @IBAction func PausePlay_Clicked(_ sender: Any) {
        if(PausePlayButton.backgroundImage(for: UIControl.State.normal) == UIImage.init(systemName: "pause.fill")){
            sceneAR.pause(nil)
            PausePlayButton.setBackgroundImage(UIImage.init(systemName: "play.fill"), for: UIControl.State.normal)
        }
        else if(PausePlayButton.backgroundImage(for: UIControl.State.normal) == UIImage.init(systemName: "play.fill")){
            sceneAR.play(nil)
            PausePlayButton.setBackgroundImage(UIImage.init(systemName: "pause.fill"), for: UIControl.State.normal)
        }
    }
    @IBAction func ConnectMedicalRecords_Clicked(_ sender: Any) {
        //    let parameters = ["id": 13, "name": "jack"]
        //let jsonIdentifier = ["use": "usual","system": "urn:oid:2.16.840.1.113883.4.1","value": "456-82-9876"]
        //let jsonName = ["use": "usual", "text": "Create Lufhir", "family": "Lufhir", "given": ["Create"]] as [String : Any]
        //let jsonRequest = ["resourceType": "Patient", "identifier": jsonIdentifier, "name": jsonName, "gender": "male",
        //                   "birthDate": "1998-06-12"] as [String : Any]
       let params = """
        {
        "resourceType": "Patient",
        "identifier": [
        {
        "use": "usual",
        "system": "urn:oid:2.16.840.1.113883.4.1",
        "value": "249-82-5928"
        }
        ],
        "name": [
        {
        "use": "usual",
        "text": "Create Lufhir",
        "family": "Lufhir",
        "given": [
        "Create"
        ]
        }
        ],
        "gender": "male",
        "birthDate": "1998-06-12
        """
        let url = URL(string: "https://fhir.epic.com/interconnect-fhir-oauth/82995619-4b42-498b-b118-289314288936/api/FHIR/R4/Patient")!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "charset=utf-8")
        request.httpMethod = "POST"
        //request.httpBody = parameters.percentEncoded()

        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                print(String(decoding: data, as: UTF8.self))
                return
            }

            //let responseString = String(data: data, encoding: .utf8)
            //print("responseString = \(responseString)")
        }

        task.resume()

    }
    @IBAction func ScreenShotButton_Clicked(_ sender: Any) {
        sceneAR.debugOptions = []
        sceneAR.pause(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let screenshot = self.sceneAR.snapshot()
            
            let rect = CGRect(x: 0, y: 0, width: screenshot.size.width, height: screenshot.size.height)

            UIGraphicsBeginImageContextWithOptions(screenshot.size, true, 0)
            screenshot.draw(in: rect, blendMode: .normal, alpha: 1)

            let result = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            ViewController.HealthImage = result
            
            UIImageWriteToSavedPhotosAlbum(result, self, #selector(self.savedImage), nil)
            self.sceneAR.debugOptions = [.showBoundingBoxes, .showConstraints, .showCreases, .showFeaturePoints, .showPhysicsFields, .showPhysicsShapes]
            
            self.sceneAR.play(nil)
        }
    }
    @objc func savedImage(_ im:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        if let err = error {
            showMessage(message: err.localizedDescription, title: "An Error Occurred")
            return
        }
        showMessage(message: "Image saved in photos, and uploaded to connected EMR records.", title: "Scene Screen Capture")
    }
    
    public func showMessage(message: String){
        //Displays a message via alert message box
        let alert = UIAlertController(title: "A Error Occured", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    public func showMessage(message: String, title: String){
        //Displays a message via alert message box
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        counter+=1;
        if(counter == 25)
        {
            DispatchQueue.main.async {
                self.sceneAR.debugOptions = []
                self.sceneAR.pause(nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let screenshot = self.sceneAR.snapshot()
                
                let rect = CGRect(x: 0, y: 0, width: screenshot.size.width, height: screenshot.size.height)

                UIGraphicsBeginImageContextWithOptions(screenshot.size, true, 0)
                screenshot.draw(in: rect, blendMode: .normal, alpha: 1)

                let result = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                ViewController.HealthImage = result
                
                self.sceneAR.debugOptions = [.showBoundingBoxes, .showConstraints, .showCreases, .showFeaturePoints, .showPhysicsFields, .showPhysicsShapes]
                
                self.loadDetectionScreen()
            }

        }
    }
    func loadDetectionScreen(){
        let storyboard = UIStoryboard(name: "AIView", bundle: nil)
        let newView = storyboard.instantiateViewController(withIdentifier: "AIViewController")
        newView.modalPresentationStyle = .formSheet
        show(newView, sender: self)
    }
    func resumeAR(){
        counter = 0
        sceneAR.play(nil)
    }
}
