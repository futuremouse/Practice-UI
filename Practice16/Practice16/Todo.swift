//
//  Todo.swift
//  Practice16
//
//  Created by t2023-m0024 on 1/11/24.
//

import Foundation

struct Todo: Codable {
    let id: Int
    var description: String
    var isDone : Bool
    var category: String
}

extension Todo {
    init(description: String, category: String) {
        self.id = UUID().hashValue
        self.description = description
        self.isDone = false
        self.category = category
    }
}
