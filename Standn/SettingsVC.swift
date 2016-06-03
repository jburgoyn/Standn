//
//  SettingsVC.swift
//  Standn
//
//  Created by Jonny B on 5/29/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    
    // Outlets
    
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var weightSpinner: UIPickerView!
    
    // Variables 
    
    var weights = [Int]()
    var userWeight = Int()
    let preference = NSUserDefaults.standardUserDefaults()
    
    // Functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createWeights()
        
        
        weightSpinner.delegate = self
        weightSpinner.dataSource = self
        
        if let weight = preference.objectForKey("userWeight") as? Int {
            
            weightSpinner.selectRow(weights[weight - 50], inComponent: 0, animated: false)
            
        } else {
            
        weightSpinner.selectRow(weights[80], inComponent: 0, animated: false)
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let weight = preference.objectForKey("userWeight") as? Int {
            
            weightSpinner.selectRow(weights[weight - 100], inComponent: 0, animated: false)
            weightLbl.text = "\(weight)"
            
        } else {
            
            weightSpinner.selectRow(weights[80], inComponent: 0, animated: false)
            weightLbl.text = "180"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToHome(sender: AnyObject) {
        
        self.performSegueWithIdentifier("returnHome", sender: self)

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == weightSpinner {
            
        return weights.count
            
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(weights[row])"
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        userWeight = weights[row]
        weightLbl.text = "\(userWeight)"
        preference.setInteger(userWeight, forKey: "userWeight")
        
    }
    
    
    
    func createWeights() {
        
        var x = 50
        
        while (x < 600) {
            
            weights.append(x)
            x += 1
            
        }
    }


}
