 //
 //  Detailed.swift
 //

 import UIKit
 import Foundation
 import Firebase
 import FirebaseCore
 import FirebaseAnalytics
 import FirebaseDatabase

 
 class Detailed: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()

    var name: String!
    var id:String!
    var theData:[UIImage] = []
    
    @IBOutlet weak var theLabel: UILabel!
    
    var anonymous = ""
    
    @IBOutlet weak var sellerLable: UILabel!
    @IBOutlet weak var images: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("number of pics received is \(theData.count)")
        
        theLabel.text = name
        
        self.navigationItem.title = name
        
        images.delegate = self
        images.backgroundColor = UIColor.white
        images.dataSource=self
        images.register(MyCell1.self, forCellWithReuseIdentifier: "cell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 150)
        images.collectionViewLayout=layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref.child("items").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let price = value?["price"] as? String ?? ""
            let description = value?["description"] as? String ?? ""
            let image1 = value?["image1"] as? String ?? ""
            let image2 = value?["image2"] as? String ?? ""
            let image3 = value?["image3"] as? String ?? ""
            let seller = value?["seller"] as? String ?? ""
            let anonymous = value?["anonymous"] as? String ?? ""
            
            
            self.priceLabel.text = price
            self.descriptionLabel.text = description
            if (anonymous == "false") {
                self.sellerLable.text = seller
            } else {
                self.sellerLable.text = "Anonymous"
            }
            
            if (image1 != "") {
                let url = URL(string: image1)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                self.theData.append(image!)
            }
            
            if (image2 != "") {
                let url = URL(string: image2)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                self.theData.append(image!)
            }
            
            if (image3 != "") {
                let url = URL(string: image3)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                self.theData.append(image!)
            }
        
            
            print("number of pics when fetching data is \(self.theData.count)")
            
            self.images.reloadData()
            
            
            /*for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
             let itemValue = rest.value as! Dictionary<String, AnyObject>
             let id = rest.key
             let price = itemValue["price"] as? String ?? ""
             let description = itemValue["description"] as? String ?? ""
             let image1 = itemValue["image1"] as? String ?? ""
             let image2 = itemValue["image2"] as? String ?? ""
             let image3 = itemValue["image3"] as? String ?? ""
             let seller = itemValue["seller"] as? String ?? ""
             let anonymous = itemValue["anonymous"] as? String ?? ""
             
             detailedVC.priceLabel.text = price
             detailedVC.descriptionLabel.text = description
             detailedVC.id = id
             detailedVC.sellerLable.text = seller
             detailedVC.anonymous = anonymous
             
             if (image1 != "") {
             let url = URL(string: image1)
             let data = try? Data(contentsOf: url!)
             let image = UIImage(data: data!)
             self.imageData.append(image!)
             }
             
             if (image2 != "") {
             let url = URL(string: image2)
             let data = try? Data(contentsOf: url!)
             let image = UIImage(data: data!)
             self.imageData.append(image!)
             }
             
             if (image3 != "") {
             let url = URL(string: image3)
             let data = try? Data(contentsOf: url!)
             let image = UIImage(data: data!)
             self.imageData.append(image!)
             }
             
             print("number of pics when fetching data is \(self.imageData.count)")
             
             }*/
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func purchase(_ sender: UIButton) {
        self.ref.child("items").child(id).child("status").setValue("waitingForApproval")
        self.ref.child("items").child(id).child("buyer").setValue(FIRAuth.auth()?.currentUser?.uid)

        let alertController = UIAlertController(title: "", message:
            "Unlike UA，we are not going to knock you down and drag u out.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        sender.isUserInteractionEnabled = false
        sender.setTitleColor(UIColor.gray, for: .disabled)
        
        
    }
    //add the movie to favorite
    @IBAction func add(_ sender: AnyObject) {
        var storedData=UserDefaults.standard.object(forKey: "favoriteMovie") as? [String] ?? [String]()
        if !storedData.contains(name){
            storedData.append(name)
        }
        UserDefaults.standard.set(storedData,forKey: "favoriteMovie")
        UserDefaults.standard.synchronize()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell1
        cell.backgroundColor = UIColor.clear
        cell.imageView?.image = theData[indexPath.item]
        
        return cell
    }

 }
