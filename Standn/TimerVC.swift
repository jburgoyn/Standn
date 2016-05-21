//
//  TimerVC.swift
//  Standn
//
//  Created by Jonny B on 5/11/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    
    // Variables
    
    var timerData = [Int]()
    var hours = Int()
    var count = Int()
    
    var staticStanding = Int()
    var staticSitting = Int()
    
    var minutesSitting = Int()
    var minutesStanding = Int()
    var timer = NSTimer()
    
    var startTime = NSDate()
    var endTime: NSDate!
    var currentTime: NSDate!
    
    var notificationTimes = [NSDate]()
    var notifications = [UILocalNotification]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hours = timerData[0]
        minutesStanding = timerData[1]
        
        count = hours
        
        minutesSitting = 60 - minutesStanding
        timerLbl.text = String(minutesSitting)
        
        staticSitting = minutesSitting
        staticStanding = minutesStanding
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"startTimer", name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"pauseTimerResign", name:
            UIApplicationWillResignActiveNotification, object: nil)
        
        for cycle in 1 ... count {
            
           
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
                
            } else {
                
                let notification = UILocalNotification()
                
                notification.alertBody = "Way to go! You may sit back down."
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.fireDate = notificationTimes[cycle]
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            
        }
        
        
        startTimer()
        
        endTime = startTime.dateByAddingTimeInterval(Double(hours) * 60)
        
        
    }
    
    
    
    @IBAction func pauseTimer(sender: AnyObject) {
        
        // Pause the timer
    }
    
    @IBAction func endSchedule(sender: AnyObject) {
        
        // End the current schedule, invalidate the notifications, and return to home screen to reset schedule.
    }
    
    
    func pauseTimerResign() {
        
        timer.invalidate()
    }
    
    
    
    func startTimer(){
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
        
    }
    
    func update() {
        
        print("****************")
        currentTime = NSDate()
        let timeElapsed = Int(currentTime.timeIntervalSinceDate(startTime))
        print("\(timeElapsed) seconds have passed since beginning schedule")
    
        let calendar = NSCalendar.currentCalendar()
        let startTimeSecond = calendar.component(.Second, fromDate: startTime)
        let currentTimeSecond = calendar.component(.Second, fromDate: currentTime)
        
      
        print("\(startTimeSecond) start time seconds")
        print("\(currentTimeSecond) current time seconds")
        
        if (currentTimeSecond - startTimeSecond) > 0 {
            
            print("Greater than zero")
            
            if (currentTimeSecond - startTimeSecond) <= staticSitting {
                
                stateLbl.text = "Sitting"
                minutesSitting = staticSitting - (currentTimeSecond - startTimeSecond)
                timerLbl.text = String(minutesSitting)
                
                
            } else if (currentTimeSecond - startTimeSecond) > staticSitting {
                
                stateLbl.text = "Standing"
                minutesStanding = startTimeSecond - currentTimeSecond + 60
                timerLbl.text = String(minutesStanding)
                print(minutesStanding)
                
            }
            
        } else if (currentTimeSecond - startTimeSecond) <= 0 {
            
             print("Less than zero")
            
            if (currentTimeSecond - startTimeSecond + 60) <= staticSitting {
                
                stateLbl.text = "Sitting"
                minutesSitting = staticSitting - (currentTimeSecond + 60 - startTimeSecond)
                timerLbl.text = String(minutesSitting)
                
            } else if (currentTimeSecond - startTimeSecond + 60) > staticSitting {
                
                stateLbl.text = "Standing"
                minutesStanding = startTimeSecond - currentTimeSecond
                timerLbl.text = String(minutesStanding)
                
            }
            
        }
        
        
        
//        if (count > 0 ) {
//            
//            if (minutesSitting > 0) {
//                
//                timerLbl.text = String(minutesSitting)
//                minutesSitting -= 1
//
//                print(minutesSitting)
//                print(staticSitting)
//                
//            } else if (minutesStanding > 0) {
//                
//                
//                timerLbl.text = String(minutesStanding)
//                minutesStanding -= 1
//                
//                print(minutesStanding)
//                print(staticStanding)
//                
//            } else if (minutesSitting == 0 && minutesStanding == 0) {
//                
//                timerLbl.text = "0"
//                minutesSitting = staticSitting
//                minutesStanding = staticStanding
//                count -= 1
//                print("Count = \(count)")
//                
//            }
//            
//            
//        } else {
//            
//            print("Finished work day")
//            timer.invalidate()
//            
//        }
        
    }
    
    
    
    
}
