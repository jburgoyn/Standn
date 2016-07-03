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
    
    var staticStanding = Int()
    var staticSitting = Int()
    
    var minutesSitting = Int()
    var minutesStanding = Int()
    var timer = NSTimer()
    
    var startTime = NSDate()
    var endTime: NSDate!
    var currentTime: NSDate!
    
    var notificationTimes = [NSDate]()
    
//    var paused: Bool = false
    var preference = NSUserDefaults.standardUserDefaults()
    
    var progress = KDCircularProgress()
    
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        user.retrieveUserSettings()
        timerLbl.text = String(user.minutesSitting)
        
        staticSitting = user.minutesSitting
        staticStanding = user.minutesStanding
        endTime = startTime.dateByAddingTimeInterval(Double(user.userHours) * 60 * 60)
        
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(TimerVC.pauseTimerResign), name:
//            UIApplicationWillResignActiveNotification, object: nil)
        
        
        user.createNotifications()
        createCircularProgress()
        startTimer()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(TimerVC.startTimer), name:
//            UIApplicationWillEnterForegroundNotification, object: nil)
        
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
    
//    @IBAction func pauseTimer(sender: AnyObject) {
//        
//        if paused == false {
//            
//            timer.invalidate()
//            paused = true
//            pauseButton.setTitle("Resume", forState: .Normal)
//            
//        } else {
//            
//            startTimer()
//            paused = false
//            pauseButton.setTitle("Pause", forState: .Normal)
//        }
//    }
    
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
        
        print("****************")
        currentTime = NSDate()
        let timeElapsed = Int(currentTime.timeIntervalSinceDate(startTime))
        print("\(timeElapsed) seconds have passed since beginning schedule")
        
        let calendar = NSCalendar.currentCalendar()
        let startTimeSecond = calendar.component(.Minute, fromDate: startTime)
        let currentTimeSecond = calendar.component(.Minute, fromDate: currentTime)
        
        
        print("\(startTimeSecond) start time seconds")
        print("\(currentTimeSecond) current time seconds")
        print("timeElapsed = \(timeElapsed)")
        
        
        if currentTimeSecond - startTimeSecond > 0 {
            
            if endTime.timeIntervalSinceNow.isSignMinus {
                
                print("Schedule Complete")
                timerLbl.text = "0"
                progress.angle = 0
                timer.invalidate()
                user.calculateCalorieBurn(user.userWeight, calorieLbl: calorieCountLbl, startTime: startTime, endTime: endTime, currentTime: currentTime)
                
                
            } else {
                
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
                        user.calculateCalorieBurn(user.userWeight, calorieLbl: calorieCountLbl, startTime: startTime, endTime: endTime, currentTime: currentTime)
                        print("This is where the problem is")
                        
                        
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
                        user.calculateCalorieBurn(user.userWeight, calorieLbl: calorieCountLbl, startTime: startTime, endTime: endTime, currentTime: currentTime)
                        print("This is where the problem is")
                        
                        
                    }
                }
            } // End
            
        }
        
    }
    
}
