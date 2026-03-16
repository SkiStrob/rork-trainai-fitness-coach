import UserNotifications
import Foundation

enum NotificationService {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    static func scheduleWorkoutReminder(workoutName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Train"
        content.body = "Today's workout: \(workoutName)"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "workout_reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func scheduleMealReminder() {
        let times = [(12, 30, "lunch_reminder", "Log Your Lunch", "Snap a photo to stay on track with your macros."),
                     (19, 0, "dinner_reminder", "Log Your Dinner", "Keep your streak alive. Quick scan takes 3 seconds.")]
        for (hour, minute, id, title, body) in times {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            var dc = DateComponents()
            dc.hour = hour
            dc.minute = minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }

    static func scheduleWeeklyReport() {
        let content = UNMutableNotificationContent()
        content.title = "Your Weekly Report is Ready"
        content.body = "See how your physique and nutrition changed this week."
        content.sound = .default
        content.badge = 1
        var dc = DateComponents()
        dc.weekday = 1
        dc.hour = 18
        dc.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: "weekly_report", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func scheduleScanReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Scan Day"
        content.body = "Time for your weekly body scan. See how your score changed."
        content.sound = .default
        content.badge = 1
        var dc = DateComponents()
        dc.weekday = 1
        dc.hour = 10
        dc.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: "scan_reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func scheduleScanReminder(daysFromNow: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Scan Day"
        content.body = "Time for your weekly body scan. Track your progress!"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(daysFromNow * 86400), repeats: false)
        let request = UNNotificationRequest(identifier: "scan_reminder_once", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func sendPRCelebration(exercise: String, weight: Double) {
        let content = UNMutableNotificationContent()
        content.title = "New PR!"
        content.body = "You just set a new personal record on \(exercise): \(Int(weight)) lbs!"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "pr_\(UUID().uuidString)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func scheduleStreakWarning() {
        let content = UNMutableNotificationContent()
        content.title = "Streak at Risk"
        content.body = "Don't lose your streak! Log a workout or meal today."
        content.sound = .default
        var dc = DateComponents()
        dc.hour = 21
        dc.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: "streak_warning", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func setupAllNotifications(workoutName: String) {
        scheduleWorkoutReminder(workoutName: workoutName)
        scheduleMealReminder()
        scheduleWeeklyReport()
        scheduleScanReminder()
        scheduleStreakWarning()
    }

    // MARK: - Additional Controls

    static func updateWorkoutReminder(workoutName: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["workout_reminder"])
        scheduleWorkoutReminder(workoutName: workoutName)
    }

    static func cancelStreakWarningForToday() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["streak_warning"])
        scheduleStreakWarning()
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}