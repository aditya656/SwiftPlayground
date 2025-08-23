//
//  Item.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//


import SwiftUI

// MARK: - Data Model

struct Item: Identifiable, Equatable {
    let id: Int
    let title: String
    let color: Color
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Grid Item View

struct GridItemView: View {
    let item: Item
    var isSelected: Bool
    var onSelect: (Item) -> Void

    var body: some View {
        Text(item.title)
            .font(.headline)
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(item.color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .opacity(isSelected ? 0.7 : 1.0)
            .animation(.spring, value: isSelected)
            .onTapGesture {
                onSelect(item)
            }
    }
}

// MARK: - Full-Screen Item View

struct FullScreenItemView: View {
    let item: Item
    var onDeselect: () -> Void

    @State private var isScaled: Bool = false

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        onDeselect()
                    }
                }

            // Fullscreen content with scaling animation
            VStack {
                Spacer()

                Text(item.title)
                    .font(.largeTitle)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(item.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .scaleEffect(isScaled ? 1.0 : 0.8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), value: isScaled)
                    .onTapGesture {
                        withAnimation(.spring) {
                            onDeselect()
                        }
                    }

                Spacer()
            }
            .padding()
            .onAppear {
                withAnimation {
                    isScaled = true
                }
            }
        }
        .transition(.opacity)
    }
}

// MARK: - Main ContentView

struct GPTContentView: View {
    // Define grid columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // Sample data
    let items: [Item] = [
        Item(id: 1, title: "Red", color: .red),
        Item(id: 2, title: "Green", color: .green),
        Item(id: 3, title: "Blue", color: .blue),
        Item(id: 4, title: "Orange", color: .orange),
        Item(id: 5, title: "Purple", color: .purple),
        Item(id: 6, title: "Yellow", color: .yellow),
        Item(id: 7, title: "Pink", color: .pink),
        Item(id: 8, title: "Teal", color: .teal),
        Item(id: 9, title: "Indigo", color: .indigo),
        // Add more items as needed
    ]

    // State to track selected item
    @State private var selectedItem: Item? = nil

    var body: some View {
        ZStack {
            // Background ScrollView with LazyVGrid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items) { item in
                        GridItemView(
                            item: item,
                            isSelected: selectedItem?.id == item.id,
                            onSelect: { selected in
                                withAnimation(.spring) {
                                    selectedItem = selected
                                }
                            }
                        )
                        .disabled(selectedItem != nil && selectedItem?.id != item.id)
                        // Disable other items when one is selected
                    }
                }
                .padding()
            }

            // Fullscreen overlay
            if let selectedItem = selectedItem {
                FullScreenItemView(item: selectedItem) {
                    withAnimation(.spring) {
                        self.selectedItem = nil
                    }
                }
                .zIndex(1) // Ensure overlay is on top
            }
        }
        .animation(.spring, value: selectedItem)
    }
}

// MARK: - Preview
#Preview {
    GPTContentView()
}
