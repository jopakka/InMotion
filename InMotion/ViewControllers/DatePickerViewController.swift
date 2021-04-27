//
//  DatePickerViewController.swift
//  InMotion
//
//  Created by iosdev on 16.4.2021.
//

import FSCalendar
import UIKit

class DatePickerViewController: UIViewController, FSCalendarDelegate  {

    var dateString: String?

    @IBOutlet var calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }


    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd-MM-YYYY"
        let date = formatter.string(from: date)
        dateString = date
        print(date)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SelectedDateDetailsViewController{
            destVC.date = dateString
        }
        }
}

