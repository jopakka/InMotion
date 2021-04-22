//
//  DatePickerViewController.swift
//  InMotion
//
//  Created by iosdev on 16.4.2021.
//

import FSCalendar
import UIKit

class DatePickerViewController: UIViewController, FSCalendarDelegate {

    @IBOutlet var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        print("screen loaded now")
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        calendar.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: view.frame.size.width)
//        view.addSubview(calendar)
//    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print(string)
    }
}

