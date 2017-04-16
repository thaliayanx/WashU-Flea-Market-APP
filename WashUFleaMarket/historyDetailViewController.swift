//
//  historyDetailViewController.swift
//  WashUFleaMarket
//
//  Created by Lingxin Zhao on 4/15/17.
//  Copyright © 2017 You Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class historyDetailViewController: UIViewController {
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    var id:String!
    
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buyerinfo: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sellerinfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("items").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let nametemp = value?["title"] as? String ?? ""
            let image1 = value?["image1"] as? String ?? ""
            let buyer = value?["buyer"] as? String ?? ""
            let seller = value?["seller"] as? String ?? ""
            let status=value?["status"] as? String ?? ""

            self.buyerinfo.text=buyer
            self.sellerinfo.text=seller
            self.name.text = nametemp
            
            if (image1 != "") {
                let url = URL(string: image1)
                let data = try? Data(contentsOf: url!)
                let imagetemp = UIImage(data: data!)
                self.image.image=imagetemp
            }
            if status=="forsale"{
                self.cancelButton.isEnabled=false
                self.cancelButton.setTitleColor(UIColor.gray, for: .disabled)
                self.confirmButton.isEnabled=false
                self.confirmButton.setTitleColor(UIColor.gray, for: .disabled)
            }
            
            }) { (error) in
            print(error.localizedDescription)
            
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func ClickCancel(_ sender: Any) {
        self.ref.child("items").child(id).child("status").setValue("forsale")
        self.ref.child("items").child(id).child("buyer").setValue("")
        
        let alertController = UIAlertController(title: "", message:
            "Order Cancelled", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        cancelButton.isEnabled=false
        cancelButton.setTitleColor(UIColor.gray, for: .disabled)
        confirmButton.isEnabled=false
        confirmButton.setTitleColor(UIColor.gray, for: .disabled)
        
    }

    @IBAction func ClickConfirm(_ sender: Any) {
        ref.child("items").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let buyer = value?["buyer"] as? String ?? ""
             let seller = value?["seller"] as? String ?? ""
            let currentUser=FIRAuth.auth()?.currentUser?.uid
            if buyer==currentUser{
                if(value?["status"] as? String ?? ""=="waitingForApproval"){
                    self.ref.child("items").child(self.id).child("status").setValue("buyerConfirmed")
                }
                else{
                    self.ref.child("items").child(self.id).child("status").setValue("orderConfirmed")
                }
            }
            if seller==currentUser{
                 if(value?["status"] as? String ?? ""=="waitingForApproval"){
                    self.ref.child("items").child(self.id).child("status").setValue("sellerConfirmed")
                }
                 else{
                    self.ref.child("items").child(self.id).child("status").setValue("orderConfirmed")
                }
            }
            self.ref.child("items").child(self.id).child("buyer").setValue("")
        let alertController = UIAlertController(title: "", message:
            "Order Confirmed", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        }) { (error) in
            print(error.localizedDescription)
        }
        cancelButton.isEnabled=false
        cancelButton.setTitleColor(UIColor.gray, for: .disabled)
        confirmButton.isEnabled=false
        confirmButton.setTitleColor(UIColor.gray, for: .disabled)
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
