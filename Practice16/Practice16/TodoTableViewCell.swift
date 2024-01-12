//
//  TodoTableViewCell.swift
//  Practice16
//
//  Created by t2023-m0024 on 1/10/24.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func didValueChanged(todoId: Int, isDone: Bool)
}

class TodoTableViewCell: UITableViewCell {
    
    var todo: Todo?
    
    static let reuseIdentifier = "myCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var strikeThroughView: UIView!

    @IBOutlet weak var isDoneSwitch: UISwitch!
    
    weak var delegate : TodoTableViewCellDelegate?
    
    
    @IBAction func didValueChanged(_ sender: Any) {
        guard let id = todo?.id else { return }
         delegate?.didValueChanged(todoId: id, isDone: isDoneSwitch.isOn)
     }
    
    func configure(with todo: Todo) {
        self.todo = todo
        titleLabel.text = todo.description
        isDoneSwitch.isOn = todo.isDone
        strikeThroughView.isHidden = !todo.isDone
    }
}
