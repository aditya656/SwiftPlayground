//
//  DropDownInScrollView.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI

struct DropDownInScrollView: View {
    @State var showDropdown: Bool = false
    @State var index: Int = 0
    let array = ["afzal",
     "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat","afzal", "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat","afzal", "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat","afzal", "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat","afzal", "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat","afzal", "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat","afzal", "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat","afzal", "pradhuman", "nikhil", "tejas", "aditya", "tj", "shaswat"]
    @State private var cellPositions: [Int: CGFloat] = [:]
    @State private var globalOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(array.indices, id: \.self) { idx in
                        VStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Text(array[idx])
                                .onTapGesture {
                                    showDropdown = true
                                    index = idx
                                }
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: CellPositionPreferenceKey.self, value: [idx: geo.frame(in: .global).minY])
                            }
                        )
                    }
                }
                .padding()
            }
            .onPreferenceChange(CellPositionPreferenceKey.self) { positions in
                cellPositions = positions
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            globalOffset = geo.frame(in: .global).minY
                        }
                        .onChange(of: geo.frame(in: .global).minY) { newOffset, _ in
                            globalOffset = newOffset
                        }
                }
            )
            if showDropdown, let cellPosition = cellPositions[index] {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 150, height: 40)
                    .position(x: Constants.Screen.width / 2, y: cellPosition - globalOffset) // Adjust y to position above
                    .onTapGesture {
                        showDropdown = false
                    }
//                Text("\(cellPosition - globalOffset)")
//                Color.clear
//                    .frame(height: 20)
//                Text("\(cellPosition)")
            }
        }
    }
}

struct CellPositionPreferenceKey: PreferenceKey {
    static let defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

#Preview {
    DropDownInScrollView()
}


