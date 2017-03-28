//
//  LoginViewController.swift
//  WashUFleaMarket
//
//  Created by thalia on 3/27/17.
//  Copyright © 2017 You Chen. All rights reserved.
//


import UIKit
import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var UserNameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNameField.borderStyle = .roundedRect
        UserNameField.placeholder="Username"
        PasswordField.placeholder="Password"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func SignUp(_ sender: Any) {
        /*FIRAuth.auth()?.createUser(withEmail: UserNameField.text!, password: PasswordField.text!) { (user, error) in
            let eduEmail = self.UserNameField.text
            let endInEdu = eduEmail?.hasSuffix("wustl.edu")
            
            if endInEdu == true {
                
                FIRAuth.auth()?.createUser(withEmail: self.UserNameField.text!, password: self.PasswordField.text!, completion: {
                    user, error in
                    
                    /*if error != nil{
                        let alert = UIAlertController(title: "User exists.", message: "Please use another email or sign in.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print(error);
                        print("Email has been used, try a different one")
                    }else{*/
                        
                        FIRAuth.auth()?.currentUser!.sendEmailVerification(completion: { (error) in
                        })
                        
                        
                        let alert = UIAlertController(title: "Account Created", message: "Please verify your email by confirming the sent link.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("This is a college email and user is created")
                        
                   // }
                    
                    
                })
                
                
            }else{
                self.showAlert()
            }
        }
 */
        if UserNameField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: UserNameField.text!, password: PasswordField.text!) { (user, error) in
                
                if error == nil {
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    FIRAuth.auth()?.currentUser!.sendEmailVerification(completion: { (error) in
                    })
                    
                    let alert = UIAlertController(title: "Account Created", message: "Please verify your email by confirming the sent link.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print("This is a college email and user is created")

                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                   // self.present(vc!, animated: true, completion: nil)
                    
                }
                else {
                    let alert = UIAlertController(title: "User exists.", message: "Please use another email or sign in.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                   // let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    //let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   // alertController.addAction(defaultAction)
                    
                   // self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func SignIn(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: UserNameField.text!, password: PasswordField.text!) { (user, error) in
            if let user = FIRAuth.auth()?.currentUser {
                if !user.isEmailVerified{
                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(self.UserNameField.text!).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                        user.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    print ("Email verified. Signing in...")
                }
            }
        }
    }
    func showAlert(){
        let alertController = UIAlertController(title: "", message:
            "This is not a wustl.edu email", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}
