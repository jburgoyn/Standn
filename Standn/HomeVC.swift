//
//  ViewController.swift
//  Standn
//
//  Created by Jonny B on 5/10/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var hoursToWorkSlider: UISlider!
    @IBOutlet weak var minutesToStandSlider: UISlider!
    
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var minutesStandLbl: UILabel!
    
    @IBOutlet weak var hourImgBar: UIImageView!
    @IBOutlet weak var minuteImgBar: UIImageView!
    
    // Variables
    
    var hours = 8
    var minutes = 15
    
    var timerData = ["hours": 8, "minutes": 15]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourImgBar.image = UIImage(named: "8")
        minuteImgBar.image = UIImage(named: "3")

    }

    
    
    
    @IBAction func hoursToWorkSliderMoved(sender: UISlider) {
        
        let interval = 1
        hours = Int(sender.value / Float(interval) ) * interval
        timerData.updateValue(hours, forKey: "hours")
        
        hoursLbl.text = String(hours)
        hourImgBar.image = UIImage(named: String(hours))
        
    }
    
    @IBAction func minutesToStandMoved(sender: UISlider) {
        
        let interval = 5
        minutes = Int(sender.value / Float(interval) ) * interval
        timerData.updateValue(minutes, forKey: "minutes")
        
        minutesStandLbl.text = String(minutes)
        minuteImgBar.image = UIImage(named: String(minutes/5))
        
    }
    
    @IBAction func startTimer(sender: CustomButton) {
        
        performSegueWithIdentifier("startTimer", sender: timerData)
        
    }
    
    @IBAction func settings(sender: UIButton) {
        
        performSegueWithIdentifier("settings", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "startTimer" {
            
            if let detailVC = segue.destinationViewController as? TimerVC {
                
                if let timerData = sender as? Dictionary<String, Int> {
                    
//                    detailVC.timerData = timerData
                }
            }
        }
    }
    
    @IBAction func returnHome(segue: UIStoryboardSegue) {}

}

