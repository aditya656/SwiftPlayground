//
//  Category.swift
//  Playground
//
//  Created by Aditya Patole on 16/01/26.
//


import SwiftUI

// MARK: - Data Model

enum Category: String, CaseIterable, Identifiable {
    case all = "All"
    case work = "Work"
    case personal = "Personal"
    case urgent = "Urgent"

    var id: String { rawValue }
}

struct MyTask: Identifiable {
    let id = UUID()
    let name: String
    let category: Category
}

// MARK: - View

struct FilteredListView: View {

    // Selected filter
    @State private var selectedCategory: Category = .all

    // Sample data
    private let MyTasks: [MyTask] = [
        MyTask(name: "Finish report", category: .work),
        MyTask(name: "Buy groceries", category: .personal),
        MyTask(name: "Pay electricity bill", category: .urgent),
        MyTask(name: "Team meeting", category: .work),
        MyTask(name: "Call parents", category: .personal)
    ]

    // Filtered MyTasks
    private var filteredMyTasks: [MyTask] {
        if selectedCategory == .all {
            return MyTasks
        }
        return MyTasks.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack(spacing: 12) {

            // Segmented Control
            Picker("Category", selection: $selectedCategory) {
                ForEach(Category.allCases) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // List / Empty State
            if filteredMyTasks.isEmpty {
                Spacer()
                Text("No items")
                    .foregroundColor(.secondary)
                    .font(.headline)
                Spacer()
            } else {
                List(filteredMyTasks) { MyTask in
                    HStack {
                        Text(MyTask.name)
                        Spacer()
                        Text(MyTask.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    FilteredListView()
}
