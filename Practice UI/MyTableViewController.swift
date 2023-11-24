//
//  MyTableViewController.swift
//  Practice UI
//
//  Created by t2023-m0024 on 11/24/23.
//

import UIKit

class MyTableViewController : UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    let friendNames: [String] = ["Henry", "Leeo", "jay","Key"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.backgroundColor = .blue
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
}
    
extension MyTableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return friendNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt
                   indexPath : IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "MyFirstCell", for: indexPath)
        cell.textLabel?.text = friendNames[indexPath.row]
        return cell
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


