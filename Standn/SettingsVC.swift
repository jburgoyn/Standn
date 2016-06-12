//
//  SettingsVC.swift
//  Standn
//
//  Created by Jonny B on 5/29/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit
import pop

class SettingsVC: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {
    
    
    // Outlets
    
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var weightSpinner: UIPickerView!
    @IBOutlet weak var hoursSpinner: UIPickerView!
    @IBOutlet weak var minutesSpinner: UIPickerView!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var minutesLbl: UILabel!
    
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var minutesView: UIView!
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var hoursSpinnerBottomBorder: UIView!
    @IBOutlet weak var minutesSpinnerBottomBorder: UIView!
    @IBOutlet weak var weightSpinnerBottomBorder: UIView!
    
    @IBOutlet weak var timerImg: CustomView!
    @IBOutlet weak var standingImg: CustomView!
    @IBOutlet weak var scaleImg: CustomView!
    
    // Variables
    
    var weights = [Int]()
    var weightsKG = [Int]()
    var userWeight = Int()
    var userWeightKG = Int()
    var userHours = Int()
    var userMinutes = Int()
    
    let preference = NSUserDefaults.standardUserDefaults()
    let hours = ["1 Hour" ,"2 Hours","3 Hours","4 Hours","5 Hours","6 Hours","7 Hours","8 Hours","9 Hours","10 Hours","11 Hours","12 Hours"]
    let minutes = ["5 Minutes","10 Minutes","15 Minutes","20 Minutes","25 Minutes","30 Minutes","35 Minutes","40 Minutes","45 Minutes","50 Minutes","55 Minutes","60 Minutes"]
    let conversion = ["lb", "kg"]
    var userConversion = "lb"
    
    var hoursSpinnerHidden = true
    var minutesSpinnerHidden = true
    var weightSpinnerHidden = true

    
    // Functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createWeights()
        createWeightsKG()
        
        weightSpinner.delegate = self
        weightSpinner.dataSource = self
        hoursSpinner.delegate = self
        hoursSpinner.dataSource = self
        minutesSpinner.delegate = self
        minutesSpinner.dataSource = self
        
        // ** Hours Settings on StartUp ** //
        
        hoursSpinner.selectRow(7, inComponent: 0, animated: false)
        
        // ** Minutes Settings on StartUp ** //
        
        minutesSpinner.selectRow(2, inComponent: 0, animated: false)

        
        // ** Weight Settings on StartUp ** //
        
        if let weight = preference.objectForKey("userWeight") as? Int {
            
            if userConversion == "lb" {
                
                weightSpinner.selectRow(weights[weight - 50], inComponent: 0, animated: false)
                userWeight = weight
                userWeightKG = weight / 2
                weightLbl.text = "\(weight) lb"
                
            } else if userConversion == "kg" {
                
                weightSpinner.selectRow(weightsKG[weight - 50], inComponent: 0, animated: false)
                userWeightKG = weight / 2
                userWeight = weight
                weightLbl.text = "\(userWeightKG) kg"
            }
            
        } else {
            
            weightSpinner.selectRow(weights[80], inComponent: 0, animated: false)
            userWeightKG = weightsKG[130]
            userWeight = weights[130]
        }
        
        // ** Conversion Settings on StartUp ** //
        
        if let userConversion = preference.objectForKey("userConversion") as? String {
            
            self.userConversion = userConversion
            
        } else {
            
            self.userConversion = "lb"
        }
        
        // ** Gesture Recognizers ** //
        
        // Hours Spinner Gestures
        let hoursTap = UITapGestureRecognizer(target: self, action: #selector(SettingsVC.hoursTap(_:)))
        hoursTap.delegate = self
        self.hoursView.addGestureRecognizer(hoursTap)
        hoursSpinner.hidden = true
        
        // Minutes Spinner Gestures
        let minutesTap = UITapGestureRecognizer(target: self, action: #selector(SettingsVC.minutesTap(_:)))
        minutesTap.delegate = self
        self.minutesView.addGestureRecognizer(minutesTap)
        minutesSpinner.hidden = true
        
        // Weight Spinner Gestures
        let weightTap = UITapGestureRecognizer(target: self, action: #selector(SettingsVC.weightTap(_:)))
        weightTap.delegate = self
        self.weightView.addGestureRecognizer(weightTap)
        weightSpinner.hidden = true

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // ** Weight Settings on StartUp ** //
        
        if let weight = preference.objectForKey("userWeight") as? Int {
            
            weightSpinner.selectRow(weights[weight - 100], inComponent: 0, animated: false)
            weightLbl.text = "\(weight) lb"
            
        } else {
            
            weightSpinner.selectRow(weights[80], inComponent: 0, animated: false)
            weightLbl.text = "180 lb"
        }
        
        // ** Conversion Settings on StartUp ** //
        
        if let userConversion = preference.objectForKey("userConversion") as? String {
            
            self.userConversion = userConversion
            
        } else {
            
            self.userConversion = "lb"
        }
        
    }
    

    
    @IBAction func backToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("returnHome", sender: self)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        if pickerView == weightSpinner {
            
            return 2
            
        } else {
            
            return 1
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == weightSpinner {
            
            if component == 0 {
                return weights.count
            } else if component == 1 {
                
                return conversion.count
            }
            
        } else if pickerView == hoursSpinner {
            
            return hours.count
            
        } else if pickerView == minutesSpinner {
            
            return minutes.count
        }
        
        return 1
        
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == weightSpinner {
            
            if component == 0 {
                
                if userConversion == "lb" {
                    
                    return "\(weights[row])"
                    
                } else if userConversion == "kg" {
                    
                    return "\(weightsKG[row])"
                }
                
            } else if component == 1 {
                
                return conversion[row]
            }
            
        } else if pickerView == hoursSpinner {
            
            return hours[row]
            
        } else if pickerView == minutesSpinner {
            
            return minutes[row]
        }
        
        return ""
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == weightSpinner {
            
            if component == 0 {
                
                if userConversion == "lb" {
                    
                    userWeight = weights[row]
                    userWeightKG = weightsKG[row]
                    weightLbl.text = "\(userWeight) lb"
                    preference.setInteger(userWeight, forKey: "userWeight")
                    weightSpinner.reloadAllComponents()
                    
                } else if userConversion == "kg" {
                    
                    userWeight = weights[row]
                    userWeightKG = weightsKG[row]
                    weightLbl.text = "\(userWeightKG) kg"
                    preference.setInteger(userWeight, forKey: "userWeight")
                    weightSpinner.reloadAllComponents()

                    
                }
                
            } else if component == 1 {
                
                weightSpinner.reloadAllComponents()
                userConversion = conversion[row]
                preference.setObject(userConversion, forKey: "userConversion")
                
                if userConversion == "lb" {
                    
                    weightLbl.text = "\(userWeight) lb"
            

                } else if userConversion == "kg" {
                    
                    weightLbl.text = "\(userWeightKG) kg"
                }
                
            }
            
        } else if pickerView == minutesSpinner {
            
            userMinutes = (row + 1) * 5
            print(userMinutes)
            minutesLbl.text = minutes[row]
            preference.setObject(userMinutes, forKey: "userMinutes")
            
        } else if pickerView == hoursSpinner {
            
            userHours = (row + 1)
            print(userHours)
            hoursLbl.text = hours[row]
            preference.setObject(userHours, forKey: "userHours")
            
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        if pickerView == weightSpinner {
            
            if component == 0 {
                
                if userConversion == "lb" {
                    
                    return setPickerFontInt(weights, row: row)

                } else if userConversion == "kg" {
                    
                    return setPickerFontInt(weightsKG, row: row)

                }
                
            } else if component == 1 {
                
                if userConversion == "lb" {
                    
                    return setPickerFont(conversion, row: row)

                } else if userConversion == "kg" {
                    
                    return setPickerFont(conversion, row: row)

                }
                
            }
            
        } else if pickerView == minutesSpinner {
            
            return setPickerFont(minutes, row: row)
            
        } else if pickerView == hoursSpinner {
        
            return setPickerFont(hours, row: row)
            
        }
        
        return UIView()
       
    }
    
    func setPickerFont(pickerData: [String], row: Int) -> UILabel{
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.darkGrayColor()
        pickerLabel.text = pickerData[row]
        pickerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
        
    }
    
    func setPickerFontInt(pickerData: [Int], row: Int) -> UILabel{
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.darkGrayColor()
        pickerLabel.text = String(pickerData[row])
        pickerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
        
    }
    
    
    func createWeights() {
        
        var x = 50
        
        while (x < 600) {
            
            weights.append(x)
            x += 1
            
        }
    }
    
    func createWeightsKG() {
        
        for weight in weights {
            
            print(weight)
            let kg = Int(weight) / 2
            weightsKG.append(kg)
            
        }
        
    }
    
    
    @IBAction func startBtnPressed(sender: AnyObject) {
        
        performSegueWithIdentifier("toTimer", sender: nil)
    }
    
    // ** Tapped Functions ** //
    
    func hoursTap(gestureRecognizer: UIGestureRecognizer) {
        
        if hoursSpinnerHidden == true {
            
            self.timerImg.scaleAnimation()
            
            UIView.animateWithDuration(0.35) { [unowned self] in
                
                self.hoursSpinner.alpha = 1
                self.hoursSpinner.hidden = false
                self.hoursSpinnerHidden = false
                self.hoursSpinnerBottomBorder.hidden = false
                
                
            }
            
        } else if hoursSpinnerHidden == false {
            
            self.hoursSpinner.alpha = 0.0
            self.hoursSpinner.hidden = true
            
            UIView.animateWithDuration(0.35) { [unowned self] in
                
                
                self.hoursSpinnerHidden = true
                self.hoursSpinnerBottomBorder.hidden = true
                
            }
        }
    }
    
    func minutesTap(gestureRecognizer: UIGestureRecognizer) {
        
        if minutesSpinnerHidden == true {
            
            self.standingImg.scaleAnimation()

            
            UIView.animateWithDuration(0.35) { [unowned self] in
                
                self.minutesSpinner.hidden = false
                self.minutesSpinnerHidden = false
                self.minutesSpinnerBottomBorder.hidden = false

            }
            
        } else if minutesSpinnerHidden == false {

            self.minutesSpinner.hidden = true

            UIView.animateWithDuration(0.35) { [unowned self] in
                
                self.minutesSpinnerHidden = true
                self.minutesSpinnerBottomBorder.hidden = true

                
            }
        }
    }
    
    func weightTap(gestureRecognizer: UIGestureRecognizer) {
        
        if weightSpinnerHidden == true {
            
            self.scaleImg.scaleAnimation()
            
            UIView.animateWithDuration(0.35) { [unowned self] in
                
                self.weightSpinner.alpha = 1
                self.weightSpinner.hidden = false
                self.weightSpinnerHidden = false
                self.weightSpinnerBottomBorder.hidden = false
                
            }
            
        } else if weightSpinnerHidden == false {
            
            self.weightSpinner.hidden = true

            
            UIView.animateWithDuration(0.35) { [unowned self] in
                
                self.weightSpinner.alpha = 0
                self.weightSpinnerHidden = true
                self.weightSpinnerBottomBorder.hidden = true
                
                
            }
        }
    }
    
    @IBAction func returnHome(segue: UIStoryboardSegue) {}
    
    
}
