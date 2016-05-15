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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateTimer", name:
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
                notification.fireDate = notificationTimes[cycle]
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            
        }
        
        
        startTimer()
        
        endTime = startTime.dateByAddingTimeInterval(Double(hours) * 60)
        
        print("\(hours) hours")
        print("\(minutesStanding) minutes")
        print(startTime)
        print(endTime)
        print(notificationTimes)
        print(notificationTimes.count)
        
    }
    
    func updateTimer() {
        
        let currentTime = NSDate()
        let timeElapsed = Int(currentTime.timeIntervalSinceDate(startTime))
        
        print(startTime)
        print(currentTime)
        print("\(timeElapsed) seconds have passed since beginning schedule")
        
        timerLbl.text = String(timeElapsed)
        startTimer()
        
    }
    
    func pauseTimerResign() {
        
        timer.invalidate()
    }
    
    
    
    func startTimer(){
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
        
    }
    
    func update() {
        
        if (count > 0) {
            
            if (minutesSitting > 0) {
                
                timerLbl.text = String(minutesSitting)
                minutesSitting -= 1
                
                print(minutesSitting)
                print(staticSitting)
                
            } else if (minutesStanding > 0) {
                
                stateLbl.text = "Standing"
                timerLbl.text = String(minutesStanding)
                minutesStanding -= 1
                
                print(minutesStanding)
                print(staticStanding)
                
            } else if (minutesSitting == 0 && minutesStanding == 0) {
                
                timerLbl.text = "0"
                stateLbl.text = "Sitting"
                minutesSitting = staticSitting
                minutesStanding = staticStanding
                count -= 1
                print("Count = \(count)")
                
            }
            
            
        } else {
            
            print("Finished work day")
            timer.invalidate()
            
        }
        
    }
    
    
    
    
}
