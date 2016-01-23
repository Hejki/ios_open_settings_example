//
//  ViewController.swift
//  OpenSettings
//
//  Created by Hejki on 23.01.16.
//  Copyright © 2016 Hejki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var urlButton: UIButton!
    
    var settingURLs = [[String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("urldict", ofType: "plist") {
            settingURLs = NSArray(contentsOfFile: path) as! [[String: AnyObject]]
        }
        
        picker.reloadAllComponents()
        pickerView(picker, didSelectRow: 0, inComponent: 0)
    }

    /**
     Here is the main open settings logic.
     */
    @IBAction func openSettings(sender: UIButton) {
        let app = UIApplication.sharedApplication()
        let url = selectedURL()
        
        if app.canOpenURL(url) {
            app.openURL(url)
        } else {
            let alert = UIAlertController(title: "URL cannot be opened", message: url.absoluteString, preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openApplicationSettings(sender: AnyObject?) {
        if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    private func selectedURL() -> NSURL! {
        let dict = settingURLs[picker.selectedRowInComponent(0)]
        let pathIndex = picker.selectedRowInComponent(1)
        let root = dict["root"] as! String
        
        if pathIndex > 0 {
            let path = dict["paths"]![pathIndex - 1]
            return NSURL(string: "prefs:root=\(root)&path=\(path)")
        }
        return NSURL(string: "prefs:root=\(root)")
    }
}

//MARK: - Picker view data source
extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return settingURLs.count
        }
        
        if let paths = settingURLs[pickerView.selectedRowInComponent(0)]["paths"] as? [String] {
            return paths.count + 1
        }
        return 0
    }
}

//MARK: - Picker view delegate
extension ViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return settingURLs[row]["root"] as? String
        case 1:
            if row == 0 {
                return ""
            } else if let paths = settingURLs[pickerView.selectedRowInComponent(0)]["paths"] as? [String] {
                return paths[row - 1]
            }
            return nil
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
        }
        
        urlButton.setTitle(selectedURL().absoluteString, forState: .Normal)
    }
}
