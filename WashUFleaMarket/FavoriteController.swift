//
//  FavoriteController.swift
//

import UIKit

class FavoriteController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        let tmp=UserDefaults.standard.object(forKey: "favoriteMovie")
        if tmp==nil{
            UserDefaults.standard.set([], forKey: "favoriteMovie")
            UserDefaults.standard.synchronize()
        }
        super.viewDidLoad()
        let data=UserDefaults.standard.array(forKey: "favoriteMovie")!
        if data.count==0{
            showAlert()
        }
        setupTableView()
        self.title = "Favorites"
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let data=UserDefaults.standard.array(forKey: "favoriteMovie")!
        if data.count==0{
            showAlert()
        }
        tableView.reloadData()
    }
    func showAlert(){
        let alertController = UIAlertController(title: "", message:
            "NO FAVORITE", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 20))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.array(forKey: "favoriteMovie")!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = UserDefaults.standard.array(forKey: "favoriteMovie")![indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var arrayInDefault=UserDefaults.standard.array(forKey: "favoriteMovie") as! [String]
            arrayInDefault.remove(at: indexPath.row)
            UserDefaults.standard.set(arrayInDefault, forKey: "favoriteMovie")
            UserDefaults.standard.synchronize()
            tableView.deleteRows(at: [indexPath], with: .right)
        }
        tableView.reloadData()
    }
    
    
}

