//
//  ViewController.swift
//  Practice8
//
//  Created by t2023-m0024 on 12/15/23.
//

import UIKit

struct Todo {
    var title: String
    var isCompleted: Bool
    // 필요한 경우 추가적인 데이터를 정의할 수 있습니다.
}

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var todos: [Todo] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        // 테스트용 초기 데이터
        todos = [
            Todo(title: "알고리즘 공부하기", isCompleted: false),
            Todo(title: "Swift 문법 익히기", isCompleted: true),
            Todo(title: "TIL 작성", isCompleted: false)
        ]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Todo 추가", style: .plain, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "새로운 할 일", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "할 일을 입력하세요"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty else {
                return
            }
            let newTodo = Todo(title: text, isCompleted: false)
            self?.todos.append(newTodo)
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 // 원하는 높이로 설정하세요
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        
        let attributeString = NSMutableAttributedString(string: todo.title)
        if todo.isCompleted {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }
        cell.textLabel?.attributedText = attributeString
        
        let segmentedControl = UISegmentedControl(items: ["미완료", "완료"])
        segmentedControl.selectedSegmentIndex = todo.isCompleted ? 1 : 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.tag = indexPath.row
        segmentedControl.frame = CGRect(x: cell.bounds.width - 160, y: 10, width: 150, height: 30)
        segmentedControl.backgroundColor = UIColor.systemGray3

        cell.addSubview(segmentedControl)
        
        return cell
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let index = sender.tag
        todos[index].isCompleted = sender.selectedSegmentIndex == 1
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
