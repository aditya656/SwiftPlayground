//
//  RunLoopModesDemoView.swift
//  Playground
//
//  Created by Aditya Patole on 19/04/26.
//


import SwiftUI

struct RunLoopModesDemoView: View {
    // Counter updated by a timer registered in `.default` mode
    @State private var defaultTicks = 0

    // Counter updated by a timer registered in `.common` modes
    @State private var commonTicks = 0

    // Keep strong references so we can invalidate the timers
    @State private var defaultTimer: Timer?
    @State private var commonTimer: Timer?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    CounterCard(
                        title: "Timer 1",
                        subtitle: "",
                        value: defaultTicks
                    )

                    CounterCard(
                        title: "Timer 2",
                        subtitle: "",
                        value: commonTicks
                    )
                }

                // A scrollable view to force the RunLoop into tracking mode
                List(0..<150, id: \.self) { index in
                    Text("Row \(index)")
                }
            }
            .padding()
            .onAppear { startTimers() }
            .onDisappear { stopTimers() }
        }
    }

    private func startTimers() {
        stopTimers()

        let defaultModeTimer = Timer(
            timeInterval: 0.2,
            repeats: true
        ) { _ in
            defaultTicks += 1
        }

        // Explicitly add the timer to the main RunLoop in `.default` mode
        RunLoop.main.add(defaultModeTimer, forMode: .default)
        defaultTimer = defaultModeTimer

        let commonModesTimer = Timer(
            timeInterval: 0.2,
            repeats: true
        ) { _ in
            commonTicks += 1
        }

        // `.common` is a set of modes (default + tracking)
        RunLoop.main.add(commonModesTimer, forMode: .common)
        commonTimer = commonModesTimer
    }

    private func stopTimers() {
        defaultTimer?.invalidate()
        commonTimer?.invalidate()
        defaultTimer = nil
        commonTimer = nil
    }
}

private struct CounterCard: View {
    let title: String
    let subtitle: String
    let value: Int

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("\(value)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .padding(.top, 4)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding()
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
        )
    }
}

#Preview {
    RunLoopModesDemoView()
}