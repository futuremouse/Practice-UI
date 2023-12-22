//
//  ViewController.swift
//  Practice 12
//
//  Created by t2023-m0024 on 12/20/23.
//
import UIKit

class ViewController: UIViewController, TodoCellDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var prettyimageView: UITableView!
    
    @IBOutlet weak var myTableView: UITableView!
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIImageView()
        self.myTableView.reloadData()
        todos.sort { $0.dueDate ?? Date() < $1.dueDate ?? Date() }
    }
        @IBAction func todolistTapped(_ sender: Any) {
            showAddTodoAlert()
        }
        func showAddTodoAlert() {
            let alert = UIAlertController(title: "새로운 할 일", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "할 일을 입력하세요"
            }
            alert.addTextField { textField in
                textField.placeholder = "Due date (MM-dd)"
                textField.keyboardType = .numbersAndPunctuation
            }
            
            let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
                guard let title = alert.textFields?.first?.text,
                      let dueDateString = alert.textFields?.last?.text,
                      !title.isEmpty else {
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd"
                let dueDate = dateFormatter.date(from: dueDateString)
                
                self?.todos.append(Todo(title: title, isCompleted: false, dueDate: dueDate))
                self?.todos.sort { $0.dueDate ?? Date() < $1.dueDate ?? Date() } // 정렬 코드 추가
                self?.myTableView.reloadData()
            }
            
            alert.addAction(addAction)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(alert, animated: true)
        }
        func todoStatusDidChange(todo: Todo) {
            guard let index = todos.firstIndex(where: { $0.title == todo.title }) else { return }
            todos[index] = todo
            myTableView.reloadData()
        }
    }
    extension ViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todos.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
            
            let todo = todos[indexPath.row]
            cell.delegate = self
            cell.configure(with: todo)
            // 셀 디자인 설정 및 여백 설정
            cell.layer.borderColor = UIColor.systemGreen.cgColor // 테두리 색상
            cell.layer.borderWidth = 1.1 // 테두리 두께
            cell.layer.cornerRadius = 8.0 // 테두리의 모서리를 둥글게
            
            let backgroundImage = UIImage(named: "dia")
            cell.backgroundView = UIImageView(image: backgroundImage)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                todos.remove(at: indexPath.row)
                myTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        // MARK: - UIImageView (공룡 2024)
        func setUIImageView() {
            let imageView1 = UIImageView()
            let image1 = UIImage(named: "ny2024")
            imageView1.image = image1
            imageView1.contentMode = .scaleToFill
            imageView1.frame = CGRect(x: 140, y: 50, width: 130, height: 110)
            self.view.addSubview(imageView1)
            
            let imageView2 = UIImageView()
            let image2 = UIImage(named: "pretty")
            imageView2.image = image2
            imageView2.contentMode = .scaleToFill
            imageView2.frame = CGRect(x: 50, y: 550, width: 300, height: 300)
            self.view.addSubview(imageView2)
        }
    }
