//
//  ViewController.swift
//  weather app
//
//  Created by Arunjot Singh on 5/4/16.
//  Copyright © 2016 Arunjot Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func findWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let place = cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-")
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + place + "/forecasts/latest")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if websiteArray?.count > 1 {
                        
                        let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 1 {
                            wasSuccessful = true
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.resultLabel.text = weatherSummary
                            })
                        }
                    }
                    if wasSuccessful == false {
                        
                        self.resultLabel.text = "Could not find the weather for that city. Please try again"
                    }
                }
            }
            task.resume()
        } else {
            
            self.resultLabel.text = "Could not find the weather for that city. Please try again"

        }
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.delegate = self
       
       //makeBlurImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        cityTextField.resignFirstResponder()
        return true
    }

    
    
    func makeBlurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = background.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        background.addSubview(blurEffectView)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}

