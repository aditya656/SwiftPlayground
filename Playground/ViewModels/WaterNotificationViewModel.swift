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
    
    let notificationTitles = [ "🚀 Locked in! Stay focused—you’re crushing it.","👀 Heads up! Mind wandering? Bring it back.", "⚡ Focus Mode: Activated. Keep pushing.","🧠 Oops—train of thought derailed. Refocus time.","🔥 You’re in the zone! Keep that momentum rolling.","🌬️ Distracted? Deep breath. Reset. Refocus.","🎯 Back on track—keep going strong.","🛰️ Mind drift detected. Refocus and win the day.","💪 On task and unstoppable.","⏳ No distractions—power through.", "👓 Focus check: On task? Sip some water 💧", "🎯 Crushing goals? Don’t forget hydration.", "🔄 Refocus, then refresh—grab a glass.", "🌊 Mind wandering? Reset + hydrate.", "🧠 Sharp mind = hydrated mind. Sip up.", "💦 Staying focused? Water helps.", "⚠️ Attention check + hydration reminder.", "🛡️ Strong focus needs fuel—drink up.", "🧘 Pause. Breathe. Hydrate. Refocus.", "💧 Water break = sharper mind.", "🏆 Eyes on the prize! Take a sip, too.", "🥇 Don’t let distractions win—hydrate & refocus.", "🌱 Stay in flow—water your brain.", "🤔 Focused or just thirsty? Try water.", "💡 Stay sharp. Stay hydrated. Stay winning.", "🚶 Stay on task—success is one sip away.", "🔄 Refocus + refresh = results.", "🕒 Hydration check: had water lately?", "⚡ Brain boost = focus + hydration.", "🔍 Almost distracted? Back to the zone.", "🎯 Focused minds achieve more. Keep going.", "💧 Hydrate. Focus. Repeat.", "🔄 Quick water break + reset time.", "⏰ Stay present—every moment counts.", "🪄 Refocus now = better later.", "🥂 Sips + success = perfect combo.", "🎉 Winning the focus game? Celebrate with water.", "🌫️ Brain fog? Pause + hydrate.", "💦 One sip = better focus.", "⚡ Reset energy. Take on the next challenge.", "🍶 Small sips = big wins.", "🚫 Don’t let distractions sneak in. Stay alert.", "💧 Focus + refresh = best combo ever.", "🔒 Stay locked in. Maybe sip some water?", "🥤 Tiny breaks, tiny sips, huge wins.", "🌟 Big dreams need small steps—like a sip now.", "🕹️ Level up your focus: drink water, stay sharp.", "💎 Clear mind = clear goals. Hydrate for clarity.", "🔥 Stay lit, not drained—water fuels focus.", "🌞 Bright ideas start with hydration.", "🧭 Lost focus? Find it with a sip.", "⚡ Power-up unlocked: drink water + refocus.", "📈 Growth hack: hydration + consistency.", "💤 Sleepy? Wake your brain with water.", "🎵 Rhythm of success: focus, sip, repeat.", "🌍 Conquer your world—stay hydrated.", "📌 Stay pinned to your goals—sip and refocus.", "🎮 Focus mode: unlocked. Keep the streak alive!", "🧩 Missing piece? Maybe it’s a sip of water.", "🚴 Push through the finish line—hydration helps.", "🌈 Clear skies ahead with a clear mind—hydrate.", "🪄 Magic formula = focus + water + persistence.", "🚦 Green light! Stay moving, stay sipping.", "📚 Smart work = smart hydration. Don’t skip it.", "🔔 Reminder: water now, better focus later.", "🥳 Celebrate small wins—start with a sip.", "🌟 Shine brighter—hydrate and refocus.", "🧊 Cool down, sip up, refocus.", "⏱️ Quick sip = quick win.", "⚓ Anchor your mind—hydrate & focus." ]

    func scheduleNotification() {
        checkForNotificationPermissionAndRequest() { [weak self] granted in
            guard let self else { return }
            if !granted {
                DispatchQueue.main.async {
                    self.alertText = "Permission denied"
                    self.showAlert = true
                }
                return
            }
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            
            for i in 1...self.count {
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
                            print("Notification scheduled successfully")
                        }
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    func checkForNotificationPermissionAndRequest(completion: @escaping ((Bool) -> Void)) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                completion(true)
                print("Notification authorization granted")
            } else {
                completion(false)
                print("Notification authorization denied")
            }
        }
    }
    
    func scheduleRoutineNotifications() {
        checkForNotificationPermissionAndRequest() { [weak self] granted in
            guard let self else { return }
            if !granted {
                DispatchQueue.main.async {
                    self.alertText = "Permission denied"
                    self.showAlert = true
                }
                return
            }
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
