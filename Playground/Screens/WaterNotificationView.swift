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
            
            GlowPillButton(title: "Notify") {
                viewModel.scheduleNotification()
            }
            .alert("Alert", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
                Button("OK", role: .confirm) {}
                Button("OK", role: .close) {}
                Button("OK", role: .destructive) {}
            } message: {
                Text("\(viewModel.alertText)")
            }
            GlowPillButton(title: "Remove All", kind: .Secondary) {
                viewModel.removeAllExistingNotifications()
            }
            Color.clear.frame(height: 50)
            GlowPillButton(title: "Add Routine Notifications", kind: .Primary) {
                viewModel.scheduleRoutineNotifications()
            }
            .alert("Alert", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("\(viewModel.alertText)")
            }
            GlowPillButton(title: "Remove Routine Notifications", kind: .Secondary) {
                viewModel.removeRoutineNotifications()
            }
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
