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

class HomeViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()

    @IBOutlet weak var items: UICollectionView!
    var theData:[Item] = []
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    
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
    
    
}

