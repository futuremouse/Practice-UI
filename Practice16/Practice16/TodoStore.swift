//
//  TodoStore.swift
//  Practice16
//
//  Created by t2023-m0024 on 1/11/24.
//

import Foundation

final class TodoStore {
    
    static var shared: TodoStore = .init()
    
    private let key = "TodoList"
    
    private init() { }
    // CRUD
    
    func readAll() -> [Todo] {
        guard let todoListData = UserDefaults.standard.data(forKey: key),
              let todoList = try? JSONDecoder().decode([Todo].self, from: todoListData)
        else {
            return [] //빈 배열 반환
        }
        return todoList
    }
    
    func readAllAndCategorize() -> [String: [Todo]] {
        
        let todoList = readAll()
        
        return Dictionary(grouping: todoList) { todo in
            todo.category //그룹화된 딕셔너리를 반환
        }
    }
    
    func add(_ todo: Todo) {
        
        var todoList = readAll()
        
        todoList.append(todo)
        
        save(todoList)
    }
    
    func delete(todoId: Int) {
        
        var todoList = readAll()
        
        todoList.removeAll { todo in
            todo.id == todoId
        }
        
        save(todoList)
    }
    
    func update(todoId: Int, isDone: Bool? = nil) {
        
        var todoList = readAll()
        
        guard let targetIndex = todoList.firstIndex(where: { $0.id == todoId }) else {
            return
        }
        
        if let newIsDone = isDone {
          todoList[targetIndex].isDone = newIsDone
        }
        
        save(todoList)
    }
    
    func updateTodoDetails(todoId: Int, newDescription: String? = nil, newCategory: String? = nil) {
        var todoList = readAll()

        guard let targetIndex = todoList.firstIndex(where: { $0.id == todoId }) else {
            return
        }

        if let updatedDescription = newDescription {
            todoList[targetIndex].description = updatedDescription
        }

        if let updatedCategory = newCategory {
            todoList[targetIndex].category = updatedCategory
        }

        save(todoList)
    }

    
    private func save(_ todoList: [Todo]) {
        guard let data = try? JSONEncoder().encode(todoList) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: key)
    }
}
