//
//  HomeViewController.swift
//  WashUFleaMarket
//
//  Created by Lingxin Zhao on 4/6/17.
//  Copyright © 2017 You Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAnalytics
import FirebaseDatabase

class HomeViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    let currentUser=FIRAuth.auth()?.currentUser?.uid


    var tappedImage:UIImageView!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var items: UICollectionView!
    var theData:[Item] = []
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBAction func IndexChanged(_ sender: UISegmentedControl) {
        
        
        switch SegmentedControl.selectedSegmentIndex
        {
        case 0:
            self.theData.removeAll()
            ref.child("items").observeSingleEvent(of: .value, with: { (snapshot) in
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let itemValue = rest.value as! Dictionary<String, AnyObject>
                    
                    let status = itemValue["status"] as? String ?? ""
                    let name = itemValue["title"] as? String ?? ""
                    let price = itemValue["price"] as? String ?? ""
                    let image = itemValue["image1"] as? String ?? ""
                    let category = itemValue["category"] as? String ?? ""
                    let seller = itemValue["seller"] as? String ?? ""
                    let id = rest.key
                    let buyer = itemValue["buyer"] as? String ?? ""
                    if buyer==FIRAuth.auth()?.currentUser?.uid{
                        self.theData.append(Item(name:name,url:image,price:price,category: category, seller: seller, id: id))
                    }
                }
                self.items.reloadData()

                // ...
            }) { (error) in
                print(error.localizedDescription)
            }

            print("at case 0")
        case 1:
            self.theData.removeAll()
            ref.child("items").observeSingleEvent(of: .value, with: { (snapshot) in
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let itemValue = rest.value as! Dictionary<String, AnyObject>
                    
                    let status = itemValue["status"] as? String ?? ""
                    let name = itemValue["title"] as? String ?? ""
                    let price = itemValue["price"] as? String ?? ""
                    let image = itemValue["image1"] as? String ?? ""
                    let category = itemValue["category"] as? String ?? ""
                    let seller = itemValue["seller"] as? String ?? ""
                    let id = rest.key
            
                    if seller==FIRAuth.auth()?.currentUser?.uid{
                        self.theData.append(Item(name:name,url:image,price:price,category: category, seller: seller, id: id))
                    }
                }
                self.items.reloadData()
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }

            print("at case 1")
        default:
            break; 
        } 

        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items.delegate = self
        items.backgroundColor = UIColor.white
        items.dataSource=self
        items.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        
        imagePicker.delegate = self
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userPhoto.isUserInteractionEnabled = true
        userPhoto.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        
        self.Name.text=FIRAuth.auth()?.currentUser?.email
        
        
        
        ref.child("items").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let itemValue = rest.value as! Dictionary<String, AnyObject>
                
                let status = itemValue["status"] as? String ?? ""
                    let name = itemValue["title"] as? String ?? ""
                    let price = itemValue["price"] as? String ?? ""
                    let image = itemValue["image1"] as? String ?? ""
                    let category = itemValue["category"] as? String ?? ""
                    let seller = itemValue["seller"] as? String ?? ""
                    let id = rest.key
                    let buyer=itemValue["buyer"] as? String ?? ""
                if buyer==FIRAuth.auth()?.currentUser?.uid{
                    self.theData.append(Item(name:name,url:image,price:price,category: category, seller: seller, id: id))
                }
            }
            
            self.items.reloadData()

            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("userPhoto").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            
            if let imageUrl = value?["\(self.currentUser)"] {
            
                if (String(describing: imageUrl) != "") {
                    let url = URL(string: imageUrl as! String)
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    self.userPhoto.image=image
                } else {
                    self.userPhoto.image=UIImage(named: "Users-User-Male-2-icon.png")
                }
            }


        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = theData[indexPath.item].name
        let url = URL(string: theData[indexPath.item].url)
        let data = try? Data(contentsOf: url!)
        cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = historyDetailViewController(nibName: "historyDetailViewController", bundle: nil)
        detailedVC.id = theData[indexPath.item].id
        print("clicked \(theData[indexPath.item])")

        navigationController?.pushViewController(detailedVC, animated: true)
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
        
        
        var data = NSData()
        if let upload1 = userPhoto.image {
            data = UIImageJPEGRepresentation(upload1, 0.8)! as NSData

            // set upload path
            let filePath = "\(currentUser)/userphoto"
            print(filePath)
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print(downloadURL)
                    //store downloadURL at database
                    
                    //let postInfo =  ["\(self.currentUser)": downloadURL]
                    
                    
                    self.ref.child("userPhoto").child("\(self.currentUser)" as String).setValue(downloadURL)
                }
                
            }
            
        }

        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
}

