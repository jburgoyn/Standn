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
    
    @IBOutlet weak var debugLabel: UILabel!
    
    // Variables
    
    var timer = NSTimer()
    var startTime = NSDate()
    var endTime: NSDate!
    
    var notificationTimes = [NSDate]()
    var preference = NSUserDefaults.standardUserDefaults()
    var progress = KDCircularProgress()
    
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user.retrieveUserSettings()
        timerLbl.text = String(user.minutesSitting)
        endTime = startTime.dateByAddingTimeInterval(Double(user.userHours) * 3600)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(pauseTimerResign), name:
            UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(startTimer), name:
            UIApplicationDidBecomeActiveNotification, object: nil)
        
        user.createNotifications()
        createCircularProgress()
        startTimer()
        
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
        
        timer.invalidate()
        
    }
    
    @IBAction func endSchedule(sender: AnyObject) {
        
        // End the current schedule, invalidate the notifications, and return to home screen to reset schedule.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        timer.invalidate()
        
        if let lifeTimeCalories = preference.objectForKey("lifeTimeCalories") as? Int {
            
            user.lifetimeCalories = lifeTimeCalories
            
        } else {
            
            user.lifetimeCalories = 0
        }
        
        user.lifetimeCalories += user.sessionCalories
        preference.setObject(user.lifetimeCalories, forKey: "lifeTimeCalories")
        user.sessionCalories = 0
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func pauseTimerResign() {
        
        timer.invalidate()
    }
    
    
    
    func startTimer(){
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimerVC.update), userInfo: nil, repeats: true)
        
    }
    
    func update() {
        
        let state = user.update(startTime, endTime: endTime, timerLbl: timerLbl, timer: timer, debugLabel: debugLabel, stateLbl: stateLbl, calorieLbl: calorieCountLbl)
       
        switch state {
            
        case "SittingPositive":
            
            progress.angle = Double(user.minutesSitting*(360/user.staticSitting))
            print("Sitting")
            
        case "StandingPositive":
            
            progress.angle = Double(user.minutesStanding*(360/user.staticStanding))
            print("Standing")
            
       case "SittingNegative":
        
            progress.angle = Double(user.minutesSitting*(360/user.staticSitting))
            print("Sitting")
            
        case "StandingNegative":
            
            progress.angle = Double(user.minutesStanding*(360/user.staticStanding))
            print("STanding")
         
        case "Spooling":
            
            print("Spooling")
            
        case "ScheduleOver":
            
            progress.angle = 0

        default:
            
            print("No State")
         
        }
        
    }
    
}
