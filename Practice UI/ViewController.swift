//
//  ViewController.swift
//  Practice UI
//
//  Created by t2023-m0024 on 11/24/23.
//

import UIKit

struct Family {
    let myName : String
    let bestFriendName : String
    let nextFriendNmae : String
    let myBrother : String
}

class ViewController: UIViewController {

    let friendNames: [String] = ["Henry", "Leeo", "jay","Key"]
    let koreanNames: [String:String] = ["Henry":"헨리", "Leeo":"리오", "jay":"제이"]
    var count: Int = 0
    let friend = Family(myName : "Henry2",
                        bestFriendName: "Leeo2",
                        nextFriendNmae: "Jay2",
                        myBrother: "Key")
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bestFriendNameLabel: UILabel!
    
    @IBOutlet weak var nextFriendNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton(_ sender: Any) {
        //        = friendNames[0]
        //        = friendNames[1]
        //        = friendNames[2]
        
        nameLabel.text = friend.myName
        bestFriendNameLabel.text = friend.bestFriendName
        nextFriendNameLabel.text = friend.nextFriendNmae
        //friend.myBrother
    }
    
}

