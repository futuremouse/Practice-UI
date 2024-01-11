//
//  ViewController.swift
//  Practice16
//
//  Created by t2023-m0024 on 1/10/24.
//

import UIKit

struct Todo: Codable {
    var title: String
    var category: String
    var isCompleted : Bool
}

struct TodoSection {
    var category: String
    var todos: [Todo]
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var amendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var todos: [Todo] = []
    
    var todoSections: [TodoSection] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUncompletedTodos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        let nib = UINib(nibName: "TodoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "myCell")
    }
    
    func loadUncompletedTodos() {
        if let savedTodos = UserDefaults.standard.data(forKey: "todos"),
           let decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedTodos) {
            
            let uncompletedTodos = decodedTodos.filter { !$0.isCompleted }
            todos = uncompletedTodos

            tableView.reloadData()
        }
    }
    
    func saveTodos() {
        let encodedData = try? JSONEncoder().encode(todos)
        UserDefaults.standard.set(encodedData, forKey: "todos")
    }
    
    func loadCompletedTodos() {
        if let savedTodos = UserDefaults.standard.data(forKey: "todos"),
           let decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedTodos) {
            let completedTodos = decodedTodos.filter { $0.isCompleted }
            todos = completedTodos
            tableView.reloadData()
        }
    }
    
    
    @IBAction func taskButtonTapped(_ sender: Any) {
        showAddTodoAlert()
    }
    
    func showAddTodoAlert() {
        let alert = UIAlertController(title: "새로운 할 일", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "할 일을 입력하세요"
        }
        alert.addTextField { textField in
            textField.placeholder = "카테고리"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { _ in
            guard let title = alert.textFields?.first?.text,
                  let category = alert.textFields?.last?.text,
                  !title.isEmpty else {
                return
            }
            
            let newTodo = Todo(title: title, category: category, isCompleted: false)
            
            self.todos.append(newTodo)
            self.saveTodos()
            self.loadUncompletedTodos()
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func amendButtonTapped(_ sender: Any) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // If a cell is selected
            showModifyTodoAlert(todoIndex: selectedIndexPath.row)
        } else {
            // If no cell is selected, you can handle it accordingly
        }
    }
    func showModifyTodoAlert(todoIndex: Int) {
        let alert = UIAlertController(title: "할 일 수정", message: nil, preferredStyle: .alert)
        
        let selectedTodo = todos[todoIndex]
        
        
        alert.addTextField { textField in
            textField.placeholder = "할 일을 수정하세요"
        }
        alert.addTextField { textField in
            textField.placeholder = "카테고리"
        }
        
        let addAction = UIAlertAction(title: "수정", style: .default) { _ in
            guard let title = alert.textFields?.first?.text,
                  let category = alert.textFields?.last?.text,
                  !title.isEmpty else {
                return
            }
            // Update the selectedTodo with new values
            var updatedTodo = selectedTodo
            updatedTodo.title = title
            updatedTodo.category = category

            // Replace the old todo with the updated one
            self.todos[todoIndex] = updatedTodo

            // Save and reload
            self.saveTodos()
            self.loadUncompletedTodos()
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Show confirmation alert before deletion
            showDeleteConfirmationAlert { confirmed in
                if confirmed {
                    // Delete the selected cell
                    self.todos.remove(at: selectedIndexPath.row)
                    
                    // Save the updated todos array to UserDefaults
                    self.saveTodos()
                    
                    // Reload the table view
                    self.loadUncompletedTodos()
                    
                    // Remove completed todos from UserDefaults
                    self.removeCompletedTodosFromUserDefaults()
                }
            }
        } else {
            // If no cell is selected, you can handle it accordingly
        }
    }

    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Delete Todo", message: "Are you sure you want to delete this todo?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //    func todoStatusDidChange(todo: Todo) {
    //        if todo.isCompleted {
    //            removeTodoFromUserDefaults()
    //        }
    //    }
    //}
    
    func removeCompletedTodosFromUserDefaults() {
        // Implement the logic to remove completed todos from UserDefaults
        if let savedTodos = UserDefaults.standard.data(forKey: "todos"),
           var decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedTodos) {
            decodedTodos.removeAll { $0.isCompleted }
            
            if let encodedData = try? JSONEncoder().encode(decodedTodos) {
                UserDefaults.standard.set(encodedData, forKey: "todos")
            }
        }
    }
}
    
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TodoTableViewCell
        
        // 셀을 재사용하지 않고 항상 새로운 셀
        let todo = todos[indexPath.row]
        cell.titleLabel.text = todo.title
        
        // Toggle action을 사용하지 않으므로 해당 부분 삭제
        
        return cell
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let encodedData = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encodedData, forKey: "todos")
        }
    }
    
}
