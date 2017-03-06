 //
 //  Detailed.swift
 //

 import UIKit
 
 class Detailed: UIViewController {
    
    var image: UIImage!
    var name: String!
    var year: String!
    var score: String!
    var rated: String!
    var id:String!
    
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var theYear: UILabel!
    @IBOutlet weak var theScore: UILabel!
    @IBOutlet weak var theRated: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        theImage.image = image
        theLabel.text = name
        theYear.text = "Released:\(year)"
        theYear.textAlignment = .center
        theScore.text="Score:\(score)/10"
        theRated.text="Rated:\(rated)"
        
        self.navigationItem.title = name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
 }
