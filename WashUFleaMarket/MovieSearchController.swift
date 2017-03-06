//
//  MovieSearchController.swift
//  LingxinZhao_Lab4F
//
//  Created by Lingxin Zhao on 10/10/16.
//  Copyright © 2016 Lingxin. All rights reserved.
//

import UIKit
import Foundation
class MovieSearchController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var clearFavorite: UIButton!
    var indicator: UIActivityIndicatorView!=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    @IBOutlet weak var yearSlider: UISlider!
    @IBOutlet weak var searchBar: UISearchBar!
    var theData:[Item]=[]
    var theDataTemp:[Item]=[]
    var theImageCache:[UIImage]=[]
    var collectionView: UICollectionView!
    var movieTitle:String=""
    var notFound:UITextView=UITextView(frame:CGRect(x: 140, y: 300, width: 200, height: 200))
    var yearArray:[Int]=[]
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        UserDefaults.standard.set([], forKey: "favoriteMovie")
        UserDefaults.standard.synchronize()
    }
    override func viewDidLoad() {
        indicator.center=view.center
        notFound.text="No Results"
        notFound.font=UIFont(name: notFound.font!.fontName, size: 20)
        setupCollectionView()
        self.title = "Movies"
        self.navigationItem.title = "Movies"
        self.view.addSubview(searchBar)
        self.searchBar.delegate = self
        super.viewDidLoad()
    }
    
    @IBAction func yearFiltered(_ sender: UISlider) {
        if theDataTemp.count==0 {
            return
        }
        else{
            print(yearArray.count)
            print(sender.value)
            if(sender.value>=0){
                let currentValue = yearArray[Int(round(sender.value))]
                print(currentValue)
                var filteredMovie:[Item]=[]
                for movie2 in theDataTemp{
                    if let year2=Int(movie2.released){
                        if year2<=currentValue{
                            filteredMovie.append(movie2)
                        }
                    }
                }
                theData=filteredMovie
                theImageCache.removeAll()
                cacheImages()
            }
        }
        collectionView.reloadData()
    }
    
    func sortFunc(_ num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        notFound.bringSubview(toFront: self.view)
        if searchBar.text != nil{
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
                self.theData.removeAll()
                self.theImageCache.removeAll()
                self.movieTitle=searchBar.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                DispatchQueue.main.async{
                    //self.view.addSubview(self.indicator)
                    self.indicator.startAnimating()
                }
                self.fetchDataForCollectionView()
                self.cacheImages()
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
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
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 150)
        
        collectionView=UICollectionView(frame:view.frame.offsetBy(dx: 0, dy: 50), collectionViewLayout:layout)
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource=self
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(indicator)
        notFound.bringSubview(toFront: self.view)
    }
    
    func fetchDataForCollectionView(){
        self.view.addSubview(indicator)
        notFound.removeFromSuperview()
        var json:JSON = JSON("")
        json=self.getJSON("http://www.omdbapi.com/?s=\(self.movieTitle)")
        if json["Error"].stringValue=="Movie not found!"{
            self.view.addSubview(self.notFound)
            notFound.bringSubview(toFront: self.view)
        }
        else{
            for result in json["Search"].arrayValue{
                let name = result["Title"].stringValue
                var rated = ""
                let url = result["Poster"].stringValue
                let released = result["Year"].stringValue
                let id=result["imdbID"].stringValue
                var score=""
                let json2=self.getJSON("http://www.omdbapi.com/?i=\(id)")
                score=json2["imdbRating"].stringValue
                rated=json2["Rated"].stringValue
                self.theData.append(Item(id:id,name:name,url:url,released:released,score:score,rated:rated))
            }
        }
        if self.theData.count==10{
            let json=self.getJSON("http://www.omdbapi.com/?s=\(self.movieTitle)&Page=2")
            if json["Error"].stringValue=="Movie not found!"{
                //self.view.addSubview(self.notFound)
            }
            else{
                for result in json["Search"].arrayValue{
                    let name = result["Title"].stringValue
                    var rated = ""
                    let url = result["Poster"].stringValue
                    let released = result["Year"].stringValue
                    let id=result["imdbID"].stringValue
                    var score=""
                    let json2=self.getJSON("http://www.omdbapi.com/?i=\(id)")
                    score=json2["imdbRating"].stringValue
                    rated=json2["Rated"].stringValue
                    self.theData.append(Item(id:id,name:name,url:url,released:released,score:score,rated:rated))
                }
            }
            
        }
        for movie in theData{
            if let year=Int(movie.released){
                print(movie.name)
                yearArray.append(year)
            }
            else{
                print("movie\(movie.name)does not have a valid year")
            }
        }
        yearArray = yearArray.sorted { $0 < $1 }
        theDataTemp=theData
        yearSlider.minimumValue=Float(0)
        yearSlider.maximumValue=Float(self.yearArray.count)-1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = theData[indexPath.item].name
        cell.imageView?.image = theImageCache[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = Detailed(nibName: "Detailed", bundle: nil)
        detailedVC.name = theData[indexPath.item].name
        detailedVC.image = theImageCache[indexPath.item]
        detailedVC.year = theData[indexPath.item].released
        detailedVC.score = theData[indexPath.item].score
        detailedVC.rated = theData[indexPath.item].rated
        detailedVC.id=theData[indexPath.item].id
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func getJSON(_ url: String) -> JSON {
        if let nsurl = URL(string: url) {
            if let data = try? Data(contentsOf: nsurl) {
                let json = JSON(data: data)
                return json
            } else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    func cacheImages() {
        for item in theData {
            let url = URL(string: item.url)
            let data = try? Data(contentsOf: url!)
            if data==nil {
                let nullImage="https://www.wired.com/wp-content/uploads/2015/11/GettyImages-134367495.jpg"
                let nullURL = URL(string: nullImage)
                let data = try? Data(contentsOf: nullURL!)
                let image = UIImage(data: data!)
                self.theImageCache.append(image!)
            }
            else{
                let image = UIImage(data: data!)
                self.theImageCache.append(image!)
            }
        }
        
    }
        
}


