//
//  TodoTableViewCell.swift
//  Practice 12
//
//  Created by t2023-m0024 on 12/20/23.
//

import UIKit
import AVFAudio

protocol TodoCellDelegate: AnyObject {
    func todoStatusDidChange(todo: Todo)
}

class TodoTableViewCell: UITableViewCell {
    var applauseSound: AVAudioPlayer?
    
    weak var delegate: TodoCellDelegate?
    var todo: Todo?
    
    @IBOutlet weak var todoTextLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    func configure(with todo: Todo?) {
        guard let currentTodo = todo else { return }

        self.todo = currentTodo
        todoTextLabel.text = currentTodo.title
        dueDateLabel.text = formatDate(currentTodo.dueDate)
        
        prepareApplauseSound()
//
        let attributeString = NSMutableAttributedString(string: currentTodo.title)
        if currentTodo.isCompleted {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }
        todoTextLabel.attributedText = attributeString
    }
        func formatDate(_ date: Date?) -> String {
            guard let date = date else { return "No due date" }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd"
            return dateFormatter.string(from: date)
        }
    // 박수 소리를 재생하기 위해 사운드 파일을 준비하는 메서드
        func prepareApplauseSound() {
            guard let soundPath = Bundle.main.path(forResource: "applause", ofType: "mp3") else {
                return
            }
            
            let soundURL = URL(fileURLWithPath: soundPath)
            
            do {
                applauseSound = try AVAudioPlayer(contentsOf: soundURL)
                applauseSound?.numberOfLoops = 3
                applauseSound?.prepareToPlay()
            } catch {
                print("박수 소리를 재생하기 위해 사운드 파일을 준비하는 도중 오류가 발생했습니다: \(error.localizedDescription)")
            }
        }
    // 완료 버튼을 눌렀을 때 박수 소리를 재생하는 메서드
    func playApplauseSound() {
            applauseSound?.play()
        }
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        guard var currentTodo = todo else { return }
        let selectedIndex = sender.selectedSegmentIndex

        if selectedIndex == 1 {
            currentTodo.isCompleted = true
            playApplauseSound()
        } else {
            currentTodo.isCompleted = false
        }

        delegate?.todoStatusDidChange(todo: currentTodo)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
}
