//
//  DatePickerViewController.swift
//  InMotion
//
//  Created by iosdev on 16.4.2021.
//

import FSCalendar
import UIKit

class DatePickerViewController: UIViewController, FSCalendarDelegate  {

    var dateSelected = Date()


    @IBOutlet var calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self

        
    }


    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateSelected = date
        print(date)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SelectedDateDetailsViewController{
            destVC.dateRecieved = dateSelected
        }
        }
}

