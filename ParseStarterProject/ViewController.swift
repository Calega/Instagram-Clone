/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signUpMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
                
            
            if signUpMode {
                
                // Sign Up
                
                let user = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: {success, error in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later"
                        
                        if let errorMessage = error as NSError? {
                            
                            displayErrorMessage = errorMessage.userInfo["error"] as! String
                            
                        }
                        
                        self.createAlert(title: "Sign up error", message: displayErrorMessage)
                    
                    } else {
                        
                        print("User sign up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })

            } else {
                
                // Log In Mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later"
                        
                        if let errorMessage = error as NSError? {
                            
                            displayErrorMessage = errorMessage.userInfo["error"] as! String
                            
                        }
                        
                        self.createAlert(title: "Log In error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("Logged In")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })
                
            }
            
            
        }
    }
    
    @IBOutlet weak var signUpLabel: UIButton!
    
    @IBOutlet weak var message: UILabel!
    
    @IBAction func changeSignUpMode(_ sender: Any) {
    
        if signUpMode {
            
            // change to login up mode
            signUpLabel.setTitle("Log In", for: [])
            
            changeSignUpMode.setTitle("Sign Up", for: [])
            
            message.text = "Dont have an account?"
            
            signUpMode = false
            
        } else {
            
            // change to sign up
            signUpLabel.setTitle("Sign Up", for: [])
            
            changeSignUpMode.setTitle("Log In", for: [])
            
            message.text = "Already have an Account?"
            
            signUpMode = true
            
            
        }
    }
    
    @IBOutlet weak var changeSignUpMode: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "showUserTable", sender: self)
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
