//
//  SettingViewController.swift
//  WashUFleaMarket
//
//  Created by Lingxin Zhao on 3/28/17.
//  Copyright © 2017 You Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseAuth

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ResetPwd(_ sender: Any) {
        let user = FIRAuth.auth()?.currentUser
        let email = user?.email;
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!, completion: { (error) in
            var title = ""
            var message = ""
            
            if error != nil {
                title = "Error!"
                message = (error?.localizedDescription)!
            } else {
                title = "Success!"
                message = "Password reset email sent."
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    @IBAction func Notification(_ sender: Any) {
        
    }
    @IBAction func LogOut(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
               self.performSegue(withIdentifier: "Logout", sender: self)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
