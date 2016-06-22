//
//  User.swift
//  Standn
//
//  Created by Jonny B on 6/18/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import Foundation

class User {
    
    // User Variables
    
    var userWeight: Int!
    var userHours: Int!
    var userMinutes: Int!
    var sessionCalories = 0
    var lifetimeCalories = 0
    var minutesSitting: Int!
    var minutesStanding: Int!
    var notificationTimes = [NSDate]()
    
    
    let preference = NSUserDefaults.standardUserDefaults()
    
    // Init
    
    init() {
        
        
    }
    
    func calculateCalorieBurn(weight: Int, calorieLbl: UILabel, startTime: NSDate, endTime: NSDate, currentTime: NSDate) {
        
        // need to address if leave app, then needs to know how long been out of app and whether or not sitting or standing so it can update.
        
        
        let timeSinceStart = currentTime.timeIntervalSinceDate(startTime)
        let whole = Double(timeSinceStart/60)
        let remainder = Double(timeSinceStart % 60)
        
        let caloriesBurnedPerMinute = (Double(weight) * 0.0053) + 0.0058
        
        print("time \(timeSinceStart)")
        print("whole \(whole)")
        print("remainder \(remainder)")
        print("calories burned per minute \(caloriesBurnedPerMinute)")
        
        if Int(whole) > 0 {
            
            print("got here 0")
            if Int(remainder) < (60 - minutesStanding) {
                
                print("got here 1")
                sessionCalories = Int(caloriesBurnedPerMinute * whole * Double(minutesStanding))

            } else if Int(remainder) > (60 - minutesStanding) {
                
                print("got here 2")
                sessionCalories = Int(caloriesBurnedPerMinute * whole * Double(minutesStanding) + caloriesBurnedPerMinute * (remainder - Double(minutesSitting)))
            }
            
        } else {
            
            if Int(remainder) < (60 - minutesStanding) {
                
                print("got here 3")
                sessionCalories = 0
                
            } else if Int(remainder) > (60 - minutesStanding) {
                
                print("got here 4")
                sessionCalories = Int(caloriesBurnedPerMinute * (remainder - Double(minutesSitting)))
                print("Session Cals\(sessionCalories)")
            }
            
        }
        
    
        //sessionCalories += caloriesBurnedPerMinute
        //lifetimeCalories += caloriesBurnedPerMinute
        
        print("Session Cals\(sessionCalories)")
        print(weight)

        calorieLbl.text = String(sessionCalories)
        
    }
    
    func retrieveUserSettings() {
        
        if let hours = preference.objectForKey("userHours") as? Int {
            
            self.userHours = hours
            
        } else {
            
            self.userHours = 8
        }
        
        if let minutes = preference.objectForKey("userMinutes") as? Int {
            
            self.userMinutes = minutes
            
        } else {
            
            self.userMinutes = 15
        }
        
        if let weight = preference.objectForKey("userWeight") as? Int {
            
            self.userWeight = weight
            
        } else {
            
            self.userWeight = 180
        }
        
        if let weight = NSUserDefaults.standardUserDefaults().objectForKey("userWeight") as? Int {
            
            self.userWeight = weight
            
        } else {
            
            self.userWeight = 180
        }
        
        minutesStanding = self.userMinutes
        minutesSitting = 60 - minutesStanding
      
        
    }
    
    func createNotifications() {
        
        for cycle in 1 ... self.userHours {
            
            
            notificationTimes.append(NSDate().dateByAddingTimeInterval(Double(cycle * minutesSitting + ((cycle - 1) * minutesStanding))))
            notificationTimes.append(NSDate().dateByAddingTimeInterval(Double(cycle * minutesStanding + cycle * minutesSitting)))
            
        }
        
        for cycle in 0 ..< notificationTimes.count {
            
            if cycle % 2 == 0 {
                
                let notification = UILocalNotification()
                
                notification.alertBody = "Time to get moving! Start standing."
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.fireDate = notificationTimes[cycle]
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
            } else if cycle == (notificationTimes.count-1) {
                
                let notification = UILocalNotification()
                
                notification.alertBody = "You have finished working for now! Check how many calories you've bruned!"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.fireDate = notificationTimes[cycle]
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
                
            } else {
                
                let notification = UILocalNotification()
                
                notification.alertBody = "Way to go! You may sit back down."
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.fireDate = notificationTimes[cycle]
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            
        }
        
    }


    
}