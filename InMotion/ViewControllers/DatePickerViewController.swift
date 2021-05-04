//
//  DatePickerViewController.swift
//  InMotion
//
//  Created by iosdev on 16.4.2021.
//

import FSCalendar
import UIKit

class DatePickerViewController: UIViewController, FSCalendarDelegate  {

    var startDate = NSDate()
    var endDate = NSDate()


    @IBOutlet var calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navbar gradient
        let image = self.navigationController!.getGradient()
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        calendar.delegate = self
        calendar.firstWeekday = 2
        calendar.scrollDirection = .vertical
        
    }


    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        startDate = date.addingTimeInterval(Double(3600 * 3)) as NSDate
        endDate = startDate.addingTimeInterval(Double(3600 * 24)) as NSDate

        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SelectedDateDetailsViewController{
            destVC.startDate = startDate
            destVC.endDate = endDate
        }
        }
    

}

