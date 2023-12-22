//
//  Todo.swift
//  Practice 12
//
//  Created by t2023-m0024 on 12/21/23.
//

import Foundation

struct Todo {
    let title: String
    var isCompleted: Bool
    var dueDate: Date?
    
    // 기타 추가 데이터 필드
    
    // 생성자 추가
    init(title: String, isCompleted: Bool, dueDate: Date?) {
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}

