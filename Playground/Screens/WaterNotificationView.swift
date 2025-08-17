//
//  WaterNotificationView.swift
//  Playground
//
//  Created by Aditya Patole on 17/08/25.
//

import SwiftUI

struct WaterNotificationView: View {
    @ObservedObject var viewModel = WaterNotificationViewModel()
    @State private var showShareSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Interval: \(viewModel.sliderValue) min")
                    .font(.title2)
                Spacer()
                Text("for: \(viewModel.count) times")
                    .font(.title2)
            }
            .padding(.horizontal, 24)
            
            HStack {
                Picker("Select Count", selection: $viewModel.sliderValue) {
                    ForEach(Array(stride(from: 15, through: 60, by: 5)), id: \.self) { num in
                        Text("\(num)").tag(num)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
                
                Picker("Select Count", selection: $viewModel.count) {
                    ForEach(1...30, id: \.self) { num in
                        Text("\(num)").tag(num)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
            }
            
            Button(action: {
                viewModel.scheduleNotification()
//                showShareSheet = true
            }, label: {
                Text("Notify")
            })
            .foregroundStyle(Color.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(.top, 24)
            .alert("Alert", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("\(viewModel.alertText)")
            }
            Button(action: {
                viewModel.removeAllExistingNotifications()
            }, label: {
                Text("Remove All")
            })
            .foregroundStyle(Color.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(.top, 24)
//            .sheet(isPresented: $showShareSheet) {
//                let url = URL(string: "https://weebz.com/zoro-sneaker")!
//                let image = UIImage(named: "AppIcon") ?? UIImage()
//                let metadataSource = LinkMetadataItemSource(url: url, title: "Zoro Lows Sneaker", subtitle: "Inspired by Wano Arc", image: image)
//                ShareSheet(activityItems: [metadataSource, "Title2", "Title3"])
//            }
            Button(action: {
                viewModel.scheduleRoutineNotifications()
//                showShareSheet = true
            }, label: {
                Text("Add Routine Notifications")
            })
            .foregroundStyle(Color.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(.top, 24)
            .alert("Alert", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("\(viewModel.alertText)")
            }
            Button(action: {
                viewModel.removeRoutineNotifications()
//                showShareSheet = true
            }, label: {
                Text("Remove Routine Notifications")
            })
            .foregroundStyle(Color.white)
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(.top, 24)
            .alert("Alert", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("\(viewModel.alertText)")
            }
        }
        .padding()
    }
}

#Preview {
    WaterNotificationView()
}
