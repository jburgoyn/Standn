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
    @IBOutlet weak var pauseButton: CustomButton!
    
    // Variables
    
    var timerData = ["hours": Int(), "minutes": Int()]
    var hours = Int()
    
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
    
    var paused: Bool = false
    
    var progress = KDCircularProgress()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hours = timerData["hours"]!
        minutesStanding = timerData["minutes"]!
        
        minutesSitting = 60 - minutesStanding
        timerLbl.text = String(minutesSitting)
        
        staticSitting = minutesSitting
        staticStanding = minutesStanding
        endTime = startTime.dateByAddingTimeInterval(Double(hours) * 60)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"startTimer", name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"pauseTimerResign", name:
            UIApplicationWillResignActiveNotification, object: nil)
        
        createNotifications()
        createCircularProgress()
        startTimer()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func createCircularProgress() {
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 225, height: 225))
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.2
        progress.clockwise = true
        progress.center = view.center
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .NoGlow
        progress.angle = 360
        progress.setColors(UIColor(colorLiteralRed: 17/255, green: 146/255, blue: 212/255, alpha: 1.0))
        view.addSubview(progress)
    }
    
    @IBAction func pauseTimer(sender: AnyObject) {
        
        if paused == false {
            
            timer.invalidate()
            paused = true
            pauseButton.setTitle("Resume", forState: .Normal)
            
        } else {
            
            startTimer()
            paused = false
            pauseButton.setTitle("Pause", forState: .Normal)
        }
    }
    
    @IBAction func endSchedule(sender: AnyObject) {
        
        // End the current schedule, invalidate the notifications, and return to home screen to reset schedule.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        timerData.removeAll()
        timer.invalidate()
        self.performSegueWithIdentifier("returnHome", sender: self)
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
                progress.angle = Double(minutesSitting*(360/staticSitting))
                
                
            } else if (currentTimeSecond - startTimeSecond) > staticSitting {
                
                stateLbl.text = "Standing"
                minutesStanding = startTimeSecond - currentTimeSecond + 60
                timerLbl.text = String(minutesStanding)
                print(minutesStanding)
                progress.angle = Double(minutesStanding*(360/staticStanding))
                
            }
            
        } else if (currentTimeSecond - startTimeSecond) <= 0 {
            
            print("Less than zero")
            
            if (currentTimeSecond - startTimeSecond + 60) <= staticSitting {
                
                stateLbl.text = "Sitting"
                minutesSitting = staticSitting - (currentTimeSecond + 60 - startTimeSecond)
                timerLbl.text = String(minutesSitting)
                progress.angle = Double(minutesSitting*(360/staticSitting))
                
            } else if (currentTimeSecond - startTimeSecond + 60) > staticSitting {
                
                stateLbl.text = "Standing"
                minutesStanding = startTimeSecond - currentTimeSecond
                timerLbl.text = String(minutesStanding)
                progress.angle = Double(minutesStanding*(360/staticStanding))
            }
            
        }
        
    }
    
    func createNotifications() {
        
        for cycle in 1 ... hours {
            
            
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
        
    }
    
}
