//
//  UploadViewController.swift
//  WashUFleaMarket
//
//  Created by Lingxin Zhao on 4/6/17.
//  Copyright © 2017 You Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    var tappedImage:UIImageView!
    var category:String!
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var Description: UITextField!
    @IBOutlet weak var Price: UITextField!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var CatPicker: UIPickerView!
    let optionsA = ["Electronics" ,"Clothes", "Beauty", "Shoes", "Food", "Accessories", "Furniture"]
    let imagePicker = UIImagePickerController()
    
    var ref: FIRDatabaseReference!
    let storageRef = FIRStorage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        CatPicker.delegate = self
        CatPicker.dataSource = self
        
        ref = FIRDatabase.database().reference()

        imagePicker.delegate = self
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image1.isUserInteractionEnabled = true
        image1.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image2.isUserInteractionEnabled = true
        image2.addGestureRecognizer(tapGestureRecognizer2)
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image3.isUserInteractionEnabled = true
        image3.addGestureRecognizer(tapGestureRecognizer3)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func SubmitWithName(_ sender: Any) {
        let productTitle=TitleField.text
        let productDescription=Description.text
        let productPrice=Price.text
        
        
        let postInfo = ["title": productTitle, "price": productPrice, "image1":"", "image2":"", "image3":"", "description":productDescription, "category":self.category, "seller": FIRAuth.auth()?.currentUser?.uid, "status": "forsale", "sellerEmail": FIRAuth.auth()?.currentUser?.email, "anonymous": "false"]
        
        let reference  = self.ref.child("items").childByAutoId()
        
        reference.setValue(postInfo)
        let childautoID = reference.key
        

        
        
        var data = Data()
        if let upload1 = image1.image {
            data = (UIImageJPEGRepresentation(upload1, 0.8)! as NSData) as Data
            
        // set upload path
        let filePath = "\(childautoID)/image1"
            print(filePath)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        print("weishenmenibujinqu")
        self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
            guard metaData != nil else {
                print("qianru")
                print(error?.localizedDescription as Any)
                return
            }
                print("houru")

                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                print(downloadURL)
                //store downloadURL at database
                
                self.ref.child("items/\(childautoID)/image1").setValue(downloadURL)
                self.tabBarController?.selectedIndex=1

        }
            
        }
        
        if let upload2 = image2.image {
            data = (UIImageJPEGRepresentation(upload2, 0.8)! as NSData) as Data
            
            // set upload path
            let filePath = "\(childautoID)/image2"
            print(filePath)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                guard metaData != nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print(downloadURL)
                    //store downloadURL at database
                    
                    self.ref.child("items/\(childautoID)/image2").setValue(downloadURL)
                
            }
            
        }
        
        if let upload3 = image3.image {
            data = (UIImageJPEGRepresentation(upload3, 0.8)! as NSData) as Data
            
            // set upload path
            let filePath = "\(childautoID)/image3"
            print(filePath)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                guard metaData != nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print(downloadURL)
                    //store downloadURL at database
                    
                    self.ref.child("items/\(childautoID)/image3").setValue(downloadURL)
                
            }
            
        }
        
        
    }

    
    @IBAction func Submit(_ sender: Any) {
    
        let productTitle=TitleField.text
        let productDescription=Description.text
        let productPrice=Price.text
        
        
        let postInfo = ["title": productTitle, "price": productPrice, "image1":"", "image2":"", "image3":"", "description":productDescription,"status": "forsale", "category":self.category,"sellerEmail": FIRAuth.auth()?.currentUser?.email,  "seller": FIRAuth.auth()?.currentUser?.uid, "anonymous": "true"]
        
        let reference  = self.ref.child("items").childByAutoId()
        
        reference.setValue(postInfo)
        let childautoID = reference.key
        
        
        
        
        var data = Data()
        if let upload1 = image1.image {
            data = (UIImageJPEGRepresentation(upload1, 0.8)! as NSData) as Data
            
            // set upload path
            let filePath = "\(childautoID)/image1"
            print(filePath)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                guard metaData != nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print(downloadURL)
                    //store downloadURL at database
                    
                    self.ref.child("items/\(childautoID)/image1").setValue(downloadURL)
                
            }
            
        }
        
        if let upload2 = image2.image {
            data = (UIImageJPEGRepresentation(upload2, 0.8)! as NSData) as Data
            
            // set upload path
            let filePath = "\(childautoID)/image2"
            print(filePath)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                guard metaData != nil else {
                    print("qianru")
                    print(error?.localizedDescription as Any)
                    return
                }
                    print("houru")
                    
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print(downloadURL)
                    //store downloadURL at database
                    
                    self.ref.child("items/\(childautoID)/image2").setValue(downloadURL)
                
            }
            
        }
        
        if let upload3 = image3.image {
            data = (UIImageJPEGRepresentation(upload3, 0.8)! as NSData) as Data
            
            // set upload path
            let filePath = "\(childautoID)/image3"
            print(filePath)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                guard metaData != nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print(downloadURL)
                    //store downloadURL at database
                    
                    self.ref.child("items/\(childautoID)/image3").setValue(downloadURL)
                
            }
            
        }
        
        tabBarController?.selectedIndex=1

        
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            tappedImage.contentMode = .scaleAspectFit
            tappedImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // return number of elements in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionsA.count
    }
    
    // return "content" for picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionsA[row]
    }
    
    // get currect value for picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category=optionsA[row]
    }
    

}

