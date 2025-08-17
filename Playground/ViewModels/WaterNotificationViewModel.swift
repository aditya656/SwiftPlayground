//
//  WaterNotificationViewModel.swift
//  Playground
//
//  Created by Aditya Patole on 17/08/25.
//


//
//  NotificationHandler.swift
//  Utilix
//
//  Created by Aditya Patole on 14/01/25.
//

import UIKit

@MainActor
class WaterNotificationViewModel: ObservableObject {
    @Published var sliderValue: Int = 15
    @Published var count: Int = 10
    @Published var showAlert: Bool = false
    var alertText: String = ""
    
    let notificationTitles = ["Locked in! Stay focused, you’re crushing it 🚀","Heads up! Mind wandering? Bring it back to the task 👀","Focus Mode: Activated. Keep going!","Oops, lost your train of thought? Refocus time 🧠","You’re in the zone! Keep that momentum!","Distracted? Take a deep breath and reset","Back on track! You’re doing great.","Mind drift detected! Refocus and win the day","On task and on fire! 🔥","Let’s power through—no distractions!","Focus check: Are you on task? Also, sip some water 💧","Crushing your goals? Don’t forget to hydrate!","Refocus, then refresh—grab a glass of water","Mind wandering? Recenter—and take a hydration break","Sharp mind = hydrated mind. Take a sip!","Staying focused? Hydration helps!","Attention check! And a gentle hydration reminder 💦","Keep your focus strong—drink up!","Pause, breathe, hydrate, and refocus","Water break! Keep your mind sharp and on task","Eyes on the prize! And maybe a quick sip?","Don’t let distractions win—hydrate and refocus!","Stay in the flow and water your brain","Are you focused or just thirsty? Try water!","Stay sharp, stay hydrated, stay winning","Stay on task—success is one step away!","Remember your goals! Refocus and refresh.","Hydration check: Have you had water lately?","Give your brain a boost—focus up and hydrate!","Almost distracted? Let’s get back in the zone.","Focused minds achieve more. Keep at it!","Hydrate, focus, repeat.","Time for a quick water break and a mental reset.","Stay present—every moment counts.","Refocus now for better results later.","Sips and success—both are important!","Winning the focus game? Celebrate with a drink of water!","Brain fog? Pause and hydrate.","You’re one sip away from better focus.","Refocus your energy and take on the next challenge!","A little hydration goes a long way for your mind.","Don’t let distractions sneak in—stay alert!","Focused and refreshed—best combo ever!","Stay locked in. Maybe grab a glass of water?","Small breaks and sips = big wins."]
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        
        for i in 1...count {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(sliderValue * 60 * i), repeats: false)
            content.title = getRandomTitle()
            let request = UNNotificationRequest(identifier: "reminderNotification\(i)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.alertText = "Error scheduling notification: \(error.localizedDescription)"
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        self.alertText = "Notification scheduled successfully"
                        self.showAlert = true
                        print("Notification scheduled successfully")
                    }
                }
            }
        }
    }
    
    func scheduleRoutineNotifications() {
        let routine: [(title: String, hour: Int, minute: Int)] = [
            ("Rise and Shine! New day, new opportunities.", 7, 30), // Wake up
            ("Time to Move! Hit the gym and energize yourself.", 8, 0), // Gym start
            ("Great job at the gym! Keep the momentum going.", 9, 15), // Gym end
            ("Fuel Up! Breakfast time for champions.", 9, 30), // Breakfast
            ("Standup Time! Share, sync, and shine.", 10, 45), // Standup
            ("Let’s Crush it! Focused work session begins.", 11, 0), // Work start
            ("Keep Going! Short break for lunch soon.", 12, 50), // Pre-lunch nudge
            ("Lunch Break! Recharge and refresh.", 13, 0), // Lunch
            ("Take a Power Nap! Short rest for a strong comeback.", 13, 30), // Rest
            ("Back to Work! Let’s make progress.", 14, 0), // Work resumes
            ("Great work! Snack break for energy.", 16, 30), // Snack time
            ("Back on Track! Last work push for the day.", 17, 0), // Resume work
            ("Awesome job! Dinner time, enjoy your meal.", 19, 0), // Dinner
            ("Optional Hustle! If you feel like it, keep going.", 20, 0) // Optional work
        ]
        
        for (index, task) in routine.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = task.title
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = task.hour
            dateComponents.minute = task.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "routineNotification\(index)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.alertText = "Error scheduling routine notification: \(error.localizedDescription)"
                        self.showAlert = true
                        print("Error scheduling routine notification: \(error.localizedDescription)")
                    } else {
                        self.alertText = "Routine notification scheduled!"
                        self.showAlert = true
                        print("Routine notification scheduled: \(task.title) at \(task.hour):\(String(format: "%02d", task.minute))")
                    }
                }
            }
        }
    }

    func removeRoutineNotifications() {
        // Update the count to match the number of notifications you scheduled
        let count = 14 // or routine.count if you have access to it
        let identifiers = (0..<count).map { "routineNotification\($0)" }
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
        print("All routine notifications removed.")
    }
    
    func removeAllExistingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func getRandomTitle() -> String {
        return notificationTitles.randomElement() ?? "Stay focused and hydrated!"
    }
}
