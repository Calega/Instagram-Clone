//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lucas Calegari on 10/04/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBAction func chooseAnImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated:true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info(UIImagePickerControllerOriginalImage) as? UIImage {
            
            imageToPost = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func postImage(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

    
        let post = PFObject(className: "Posts")
        
        post["message"] = textField.text
        
        post["userID"] = PFUser.current()?.objectId
        
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackground { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                self.createAlert(title: "Could not post image", message: "Please try again later")
                
            } else {
                
                self.createAlert(title: "Image Posted", message: "Your image has been posted successfuly")
                
                self.textField.text = ""
                
                self.imageToPost.image = UIImage(named: "business.jpg")
                
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
