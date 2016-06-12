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
    @IBOutlet weak var calorieCountLbl: UILabel!
    @IBOutlet weak var pauseButton: CustomButton!
    
    // Variables
    
    var userHours = Int()
    var userMinutes = Int()
    var userWeight = Int()
    
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
    var preference = NSUserDefaults.standardUserDefaults()
    
    var progress = KDCircularProgress()
    
    // Calorie Burn Variables
    var lifetimeCalories = 0.0
    var todayCalories = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        minutesStanding = userMinutes
        
        minutesSitting = 60 - minutesStanding
        timerLbl.text = String(minutesSitting)
        
        staticSitting = minutesSitting
        staticStanding = minutesStanding
        endTime = startTime.dateByAddingTimeInterval(Double(userHours) * 60)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(TimerVC.startTimer), name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(TimerVC.pauseTimerResign), name:
            UIApplicationWillResignActiveNotification, object: nil)
        
        createNotifications()
        createCircularProgress()
        startTimer()
        retrieveUserWeight()
        
        
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
        timer.invalidate()
        todayCalories = 0.0
        
        self.performSegueWithIdentifier("returnHome", sender: self)
    }
    
    
    func pauseTimerResign() {
        
        timer.invalidate()
    }
    
    
    
    func startTimer(){
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimerVC.update), userInfo: nil, repeats: true)
        
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
                calculateCalorieBurn(userWeight)
                
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
                calculateCalorieBurn(userWeight)
            }
            
        }
        
    }
    
    func createNotifications() {
        
        for cycle in 1 ... userHours {
            
            
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
    
    func calculateCalorieBurn(weight: Int) {
        
        // need to address if leave app, then needs to know how long been out of app and whether or not sitting or standing so it can update. 
        
        
        let caloriesBurnedPerMinute = (Double(userWeight) * 0.0053) + 0.0058
        todayCalories += caloriesBurnedPerMinute
        print(Int(todayCalories))
        print(userWeight)
        
        calorieCountLbl.text = String(Int(todayCalories))
        
    }
    
    func retrieveUserWeight() {
        
        if let weight = NSUserDefaults.standardUserDefaults().objectForKey("userWeight") as? Int {
            
            self.userWeight = weight
            
        } else {
            
            self.userWeight = 180
        }
        
    }
    
}
