//
//
//

import UIKit
import Foundation
import FirebaseCore
import FirebaseAnalytics
import FirebaseDatabase


class MarketViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    
    @IBOutlet weak var clearFavorite: UIButton!
    @IBOutlet weak var yearSlider: UISlider!
    @IBOutlet weak var searchBar: UISearchBar!
    var theData:[Item] = []
    var theDataTemp:[Item]=[]
    var imageData:[UIImage]=[]
    var theImageCache:[UIImage]=[]
    var collectionView: UICollectionView!
    var movieTitle:String=""
    var notFound:UITextView=UITextView(frame:CGRect(x: 140, y: 300, width: 200, height: 200))
    var priceArray:[Int]=[]
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        UserDefaults.standard.set([], forKey: "favoriteMovie")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func priceFilter(_ sender: UISlider) {
        
        if theDataTemp.count==0 {
            return
        }
        else{
            print(sender.value)
            var filteredItem:[Item]=[]
            for item in theDataTemp{
                if(String(sender.value)>=item.price){
                    filteredItem.append(item)
                }
            }
            theData=filteredItem
        }
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator.center=view.center
        //indicator.hidesWhenStopped=true
        notFound.text="No Results"
        notFound.font=UIFont(name: notFound.font!.fontName, size: 20)
        setupCollectionView()
        indicator.bringSubview(toFront: self.view)
        self.view.addSubview(searchBar)
        self.searchBar.delegate = self
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            DispatchQueue.main.async{
                self.indicator.bringSubview(toFront: self.view)
                self.indicator.startAnimating()
            }
            self.theData.removeAll()
            self.ref.child("items").observeSingleEvent(of: .value, with: { (snapshot) in
                self.indicator.startAnimating()
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let itemValue = rest.value as! Dictionary<String, AnyObject>
                    
                    let status = itemValue["status"] as? String ?? ""
                    if (status=="forsale") {
                        let name = itemValue["title"] as? String ?? ""
                        let price = itemValue["price"] as? String ?? ""
                        let image = itemValue["image1"] as? String ?? ""
                        let category = itemValue["category"] as? String ?? ""
                        let seller = itemValue["seller"] as? String ?? ""
                        let id = rest.key
                        
                        self.theData.append(Item(name:name,url:image,price:price,category: category, seller: seller, id: id))
                        self.theDataTemp = self.theData
                        var
                    }
                }
                self.collectionView.reloadData()
                //self.indicator.stopAnimating()
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            DispatchQueue.main.async{
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                
            }
        }

        
    }

    
    func sortFunc(_ num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       // notFound.bringSubview(toFront: self.view)
        self.view.bringSubview(toFront: indicator)

        self.indicator.startAnimating()

        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
        self.indicator.startAnimating()
        if searchBar.text != nil{
            self.theData.removeAll()
            self.ref.child("items").observeSingleEvent(of: .value, with: { (snapshot) in
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let itemValue = rest.value as! Dictionary<String, AnyObject>
                    
                    let status = itemValue["status"] as? String ?? ""
                    if (status=="forsale") {
                        let name = itemValue["title"] as? String ?? ""
                        let price = itemValue["price"] as? String ?? ""
                        let image = itemValue["image1"] as? String ?? ""
                        let category = itemValue["category"] as? String ?? ""
                        let seller = itemValue["seller"] as? String ?? ""
                        let id = rest.key
                        if(name.contains(searchBar.text!)){
                        self.theData.append(Item(name:name,url:image,price:price,category: category, seller: seller, id: id))
                        self.theDataTemp=self.theData
                        }
                    }
                }
                self.collectionView.reloadData()
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            DispatchQueue.main.async{
                self.collectionView.reloadData()
                //self.indicator.stopAnimating()


            }
            
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 150, right: 10)
        layout.itemSize = CGSize(width: 330, height: 250)
        
        collectionView=UICollectionView(frame:view.frame.offsetBy(dx: 0, dy: 50), collectionViewLayout:layout)
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource=self
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        notFound.bringSubview(toFront: self.view)
    }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.backgroundColor = UIColor.clear
            cell.textLabel!.text = "$\(theData[indexPath.item].price) \(theData[indexPath.item].name)"
        let url = URL(string: theData[indexPath.item].url)
        let data = try? Data(contentsOf: url!)
            cell.imageView?.image = UIImage(data: data!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = Detailed(nibName: "Detailed", bundle: nil)
        detailedVC.name = theData[indexPath.item].name
        detailedVC.id = theData[indexPath.item].id
        


        navigationController?.pushViewController(detailedVC, animated: true)
    }
}


