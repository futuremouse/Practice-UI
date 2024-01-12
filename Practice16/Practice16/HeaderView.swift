//
//  HeaderView.swift
//  Practice16
//
//  Created by t2023-m0024 on 1/11/24.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "myHeader"
    
    @IBOutlet weak var headerTitleLabel: UILabel!

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Calculate the size based on contentView's content
        let calculatedSize = contentView.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return calculatedSize
    }
}
