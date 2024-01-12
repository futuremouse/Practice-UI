//
//  MainViewController.swift
//  Practice16
//
//  Created by t2023-m0024 on 1/11/24.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var myImage: UIView!
    
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let url = URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let data = data, let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let myImageView = self.myImage {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = myImageView.bounds
                myImageView.addSubview(imageView)
            }
        }
    }
    
    task.resume()
}

}
