//
//  ViewController.swift
//  Practice16
//
//  Created by t2023-m0024 on 1/10/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var amendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var todoDict: [String: [Todo]] = TodoStore.shared.readAllAndCategorize()
    
    var todo: Todo?
    
    var sortedCategory: [String] {
        todoDict.keys.sorted { $0 < $1 }
    }

    var dataSource: [[Todo]] {
        todoDict.sorted { $0.key < $1.key }.map {$0.value}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        let nib = UINib(nibName: "HeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "myHeader")

        let todoCellNib = UINib(nibName: "TodoTableViewCell", bundle: nil)
           tableView.register(todoCellNib, forCellReuseIdentifier: "myCell")
        
 //       print(sortedSections)
    }
    
    @IBAction func taskButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "새로운 할 일", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "할 일을 입력하세요"
        }
        alert.addTextField { textField in
            textField.placeholder = "카테고리"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [self] _ in
            guard let description = alert.textFields?[0].text,
                  let category = alert.textFields?[1].text,
                  !description.isEmpty
            else {
                return
            }
            
            let todo = Todo(description: description, category: category)
            
            TodoStore.shared.add(todo)
            
            self.todoDict = TodoStore.shared.readAllAndCategorize()
            
            self.tableView.reloadData()
            
            alert.dismiss(animated: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func amendButtonTapped(_ sender: Any) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // If a cell is selected
            let selectedTodo = dataSource[selectedIndexPath.section][selectedIndexPath.row]
            showModifyTodoAlert(todo: selectedTodo)
        } else {
            
        }
    }
    
    func showModifyTodoAlert(todo: Todo) {

        let alert = UIAlertController(title: "할 일 수정", message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "할 일을 수정하세요"
            textField.text = todo.description // Set current description if available
        }
        alert.addTextField { textField in
            textField.placeholder = "카테고리"
            textField.text = todo.category // Set current category if available
        }
        
        let addAction = UIAlertAction(title: "수정", style: .default) { [self] _ in
            guard let description = alert.textFields?[0].text,
                  let category = alert.textFields?[1].text,
                  !description.isEmpty else {
                return
            }
            // Create an updated Todo instance
            let updatedTodo = Todo(id: todo.id , description: description, isDone: todo.isDone, category: category)

            // Update the Todo in the data store
            TodoStore.shared.updateTodoDetails(todoId: updatedTodo.id, newDescription: updatedTodo.description, newCategory: updatedTodo.category)
            
            // Dismiss the alert after updating data
            alert.dismiss(animated: true)
            
            self.todoDict = TodoStore.shared.readAllAndCategorize()
            
            // Reload the table view
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        }

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        present(alert, animated: true)
    }



    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow  else {
            return
        }
        
        let alert = UIAlertController(title: "Delete Todo", message: "Are you sure you want to delete this todo?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
             guard let self = self else { return }
             
             let id = self.dataSource[selectedIndexPath.section][selectedIndexPath.row].id
             
             TodoStore.shared.delete(todoId: id)
             
             self.todoDict = TodoStore.shared.readAllAndCategorize()
             
             self.tableView.reloadData()
         }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
             
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
    
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < dataSource.count else {
            return 0 // Invalid section index
        }
        return dataSource[section].count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "myHeader") as? HeaderView else {
            return nil
        }

        headerView.headerTitleLabel.text = sortedCategory[section]

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // 헤더 뷰의 높이 설정
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard (dataSource[indexPath.section][indexPath.row] as Todo?) != nil else {
                return
            }
            let id = dataSource[indexPath.section][indexPath.row].id
            
            TodoStore.shared.delete(todoId: id)
            
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"myCell",for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = dataSource[indexPath.section][indexPath.row]
        
        cell.configure(with: todo)
        cell.delegate = self
        
        return cell
    }
}
extension ViewController: TodoTableViewCellDelegate {
    func didValueChanged(todoId: Int, isDone: Bool) {
        // Read the existing Todo
        guard var existingTodo = TodoStore.shared.readAll().first(where: { $0.id == todoId }) else {
            return
        }

        // Update the isDone property
        existingTodo.isDone = isDone

        // Update the Todo in the data store
        TodoStore.shared.update(todoId: todoId, isDone: isDone)
        
        // Reload the data
        self.todoDict = TodoStore.shared.readAllAndCategorize()
        
        self.tableView.reloadData()
    }
}
