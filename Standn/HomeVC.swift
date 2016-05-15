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
    
    // Variables
    
    var hours = 8
    var minutes = 15
    
    var timerData = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func hoursToWorkSliderMoved(sender: UISlider) {
        
        let interval = 1
        hours = Int(sender.value / Float(interval) ) * interval
        
        hoursLbl.text = String(hours)
        
    }
    
    @IBAction func minutesToStandMoved(sender: UISlider) {
        
        let interval = 5
        minutes = Int(sender.value / Float(interval) ) * interval
        minutesStandLbl.text = String(minutes)
        
    }
    
    @IBAction func startTimer(sender: CustomButton) {
        
        timerData.append(hours)
        timerData.append(minutes)
        performSegueWithIdentifier("startTimer", sender: timerData)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "startTimer" {
            
            if let detailVC = segue.destinationViewController as? TimerVC {
                
                if let timerData = sender as? [Int] {
                    
                    detailVC.timerData = timerData
                }
            }
        }
    }
    


}

