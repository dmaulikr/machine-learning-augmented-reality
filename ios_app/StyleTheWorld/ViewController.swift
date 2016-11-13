//
//  ViewController.swift
//  StyleTheWorld
//
//  Created by Kevin J Reece on 11/12/16.
//  Copyright © 2016 Kevin J Reece. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    var cameraEngine: CameraEngine!
    
    var busy: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraEngine = CameraEngine()
        cameraEngine.startSession()
        cameraEngine.sessionPresset = CameraEngineSessionPreset.low
        
//        DispatchQueue.global().async {
//            while (true) {
//                DispatchQueue.main.async {
//                    self.captureImage();
//                }
//            }
//        }
        
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.captureImage), userInfo: nil, repeats: true)
    }
    
    func captureImage() {
//        if (!busy) {
//            busy = true
            self.cameraEngine.capturePhoto { (image: UIImage?, error: Error?) -> (Void) in
                if let i = image {

                    let request = NSMutableURLRequest(url: URL(string: "http://54.196.145.225/upload")!)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
            
                    let imageData = UIImagePNGRepresentation(i)
                    let base64String = imageData?.base64EncodedString()
            
                    let params = ["image": base64String!, "arttype": "wave"]
                    try! request.httpBody = JSONSerialization.data(withJSONObject: params)
            
                    let session = URLSession.shared
                    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
                        if let safeData = data {
                            print(safeData)
                            // process the response
                            let decodedData = Data(base64Encoded: safeData, options: NSData.Base64DecodingOptions())
                            let decodedimage = UIImage(data: decodedData!)
                            self.imageView.image = decodedimage! as UIImage
                        }
                        else {
                            self.imageView.image = i
                        }
                    })
            
                    task.resume() // this is needed to start the task
//                    self.imageView.image = i
                }
//            }
//            busy = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//            var imageData = UIImagePNGRepresentation(self.imageView.image!)
//
//            if imageData != nil{
//                var request = URLRequest(url: NSURL(string:"http://54.145.134.142/upload")! as URL)
//                var session = URLSession.shared
//
//                request.httpMethod = "POST"
//
//                var boundary = NSString(format: "---------------------------14737809831466499882746641449")
//                var contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
//                //  println("Content Type \(contentType)")
//                request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
//
//                var body = Data()
//
//                // Title
//                body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
//                body.append(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
//                body.append("Hello World".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
//
//                // Image
//                body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
//                body.append(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").data(using: String.Encoding.utf8.rawValue)!)
//                body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
//                body.append(imageData!)
//                body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
//
//
//
//                request.httpBody = body
//
//
//                var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//
//                var returnString = NSString(data: returnData, encoding: String.Encoding.utf8)
//
//                print("returnString \(returnString)")
//
//            }





//            let params: Parameters = [
//                "arttype": "wave",
//                "image": UIImagePNGRepresentation(self.imageView.image!)!
//            ]
//
//            Alamofire.request("http://54.145.134.142/upload", method: "POST", parameters: params).response { response in
//                self.imageView.image = response
//            }
        
