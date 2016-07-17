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
    var staticSitting: Int!
    var staticStanding: Int!
    var notificationTimes = [NSDate]()
    
    
    let preference = NSUserDefaults.standardUserDefaults()
    
    // Init
    
    init() {
        
    }
    
    func update(startTime: NSDate, endTime: NSDate, timerLbl: UILabel, timer: NSTimer, stateLbl: UILabel, calorieLbl: UILabel, debugLabel: UILabel, debugLabel2: UILabel) -> String {
        
        print("****************")
        // for debug changed currentTime from let to var
        let currentTime = NSDate()
        // Debug Current Time
        //let currentTimeDebug = currentTime.dateByAddingTimeInterval(3500)
        //currentTime = currentTimeDebug
        
        let timeElapsed = Int(currentTime.timeIntervalSinceDate(startTime))
        print("\(timeElapsed) seconds have passed since beginning schedule")
        
        let calendar = NSCalendar.currentCalendar()
        let startTimeMinute = calendar.component(.Minute, fromDate: startTime)
        let startTimeSecond = calendar.component(.Second, fromDate: startTime)
        let currentTimeMinute = calendar.component(.Minute, fromDate: currentTime)
        let currentTimeSecond = calendar.component(.Second, fromDate: currentTime)
        
        
        print("\(startTimeMinute) start time seconds")
        print("\(currentTimeMinute) current time seconds")
        print("timeElapsed = \(timeElapsed)")
        
        debugLabel2.text = "\(currentTimeSecond) Current Time Second. User"
        
        
        
        if timeElapsed > (60 - startTimeSecond) {
            
            if endTime.timeIntervalSinceNow.isSignMinus {
                
                print("Schedule Complete")
                timerLbl.text = "0"
                
                sessionCalories = Int(Double(userHours) * Double(staticStanding)*((Double(userWeight) * 0.0053) + 0.0058))
                calorieLbl.text = "\(sessionCalories)"
                timer.invalidate()
                
                debugLabel.text = "Schedule Complete. \(timeElapsed) cals: \(sessionCalories)"
                return "ScheduleOver"
                
                
            } else {
                
                if (currentTimeMinute - startTimeMinute) > 0 {
                    
                    print("Greater than zero")
                    
                    if (currentTimeMinute - startTimeMinute) <= staticSitting {
                        
                        stateLbl.text = "Sitting"
                        minutesSitting = staticSitting - (currentTimeMinute - startTimeMinute)
                        timerLbl.text = String(minutesSitting)
                        self.calculateCalorieBurn(userWeight, calorieLbl: calorieLbl, startTime: startTime, endTime: endTime, currentTime: currentTime)
                        
                        debugLabel.text = "Sitting Positive \(timeElapsed)"
                        print("Minutes sitting \(minutesSitting)")
                        return "SittingPositive"
                        
                        
                    } else if (currentTimeMinute - startTimeMinute) > staticSitting {
                        
                        stateLbl.text = "Standing"
                        minutesStanding = startTimeMinute - currentTimeMinute + 60
                        timerLbl.text = String(minutesStanding)
                        self.calculateCalorieBurn(userWeight, calorieLbl: calorieLbl, startTime: startTime, endTime: endTime, currentTime: currentTime)
                        debugLabel.text = "Standing Positive\(timeElapsed)"
                        
                        return "StandingPositive"
                        
                        
                    }
                    
                } else if (currentTimeMinute - startTimeMinute) <= 0 {
                    
                    print("Less than zero")
                    
                    if (currentTimeMinute - startTimeMinute + 60) <= staticSitting {
                        
                        stateLbl.text = "Sitting"
                        minutesSitting = staticSitting - (currentTimeMinute + 60 - startTimeMinute)
                        timerLbl.text = String(minutesSitting)
                        self.calculateCalorieBurn(userWeight, calorieLbl: calorieLbl, startTime: startTime, endTime: endTime, currentTime: currentTime)
                        debugLabel.text = "Sitting Negative\(timeElapsed)"
                        
                        return "SittingNegative"
                        
                        
                    } else if (currentTimeMinute - startTimeMinute + 60) > staticSitting {
                        
                        stateLbl.text = "Standing"
                        minutesStanding = startTimeMinute - currentTimeMinute
                        timerLbl.text = String(minutesStanding)
                        self.calculateCalorieBurn(userWeight, calorieLbl: calorieLbl, startTime: startTime, endTime: endTime, currentTime: currentTime)
                        debugLabel.text = "Standing Negatove \(timeElapsed)"
                        
                        return "StandingNegative"
                        
                    }
                    
                    debugLabel.text = "problem here 1"
                }
                
                debugLabel.text = "problem here 2"
            }
            
            debugLabel.text = "problem here 3"
        }
        
        debugLabel.text = "problem here 4"
        return "Spooling"
    }
    
    
    func calculateCalorieBurn(weight: Int, calorieLbl: UILabel, startTime: NSDate, endTime: NSDate, currentTime: NSDate) {
        
        let timeSinceStart = currentTime.timeIntervalSinceDate(startTime) / 60
        let whole = Double(timeSinceStart/60)
        let remainder = Double(timeSinceStart % 60)
        
        let caloriesBurnedPerMinute = (Double(weight) * 0.0053) + 0.0058
        
        print("time \(timeSinceStart)")
        print("whole \(whole)")
        print("remainder \(remainder)")
        print("calories burned per minute \(caloriesBurnedPerMinute)")
        
        if Int(whole) > 0 {
            
            print("got here 0")
            if Int(remainder) < (60 - staticStanding) {
                
                print("got here 1")
                sessionCalories = Int(caloriesBurnedPerMinute * Double(Int(whole) * staticStanding))
                
            } else if Int(remainder) > (60 - staticStanding) {
                
                print("got here 2")
                sessionCalories = Int(caloriesBurnedPerMinute * Double(Int(whole) * staticStanding) + caloriesBurnedPerMinute * (remainder - Double(staticSitting)))
            }
            
        } else {
            
            if Int(remainder) < (60 - staticStanding) {
                
                print("got here 3")
                sessionCalories = 0
                
            } else if Int(remainder) > (60 - staticStanding) {
                
                print("got here 4")
                sessionCalories = Int(caloriesBurnedPerMinute * (remainder - Double(staticSitting)))
                print("Session Cals\(sessionCalories)")
            }
            
        }
        
        
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
        staticStanding = minutesStanding
        staticSitting = minutesSitting
    }
    
    func createNotifications() {
        
        for cycle in 1 ... self.userHours {
            
            
            notificationTimes.append(NSDate().dateByAddingTimeInterval(Double(60 * (cycle * minutesSitting + ((cycle - 1) * minutesStanding)))))
            notificationTimes.append(NSDate().dateByAddingTimeInterval(Double(60 * (cycle * minutesStanding + cycle * minutesSitting))))
            
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
                
                notification.alertBody = "You have finished working for now! Check how many calories you've burned!"
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