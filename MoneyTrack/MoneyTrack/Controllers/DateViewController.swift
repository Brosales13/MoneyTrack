//
//  DateViewController.swift
//  MoneyTrack
//
//  Created by Brian Rosales on 6/20/22.
//

import Foundation
import UIKit

class DateViewController: UIViewController {
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var removeDate: UIButton!
    
    var dateDelegate: DateDelegate?
    
    @IBAction func dateSaveButton (_sender: UIButton){
        // "isDateFeatureOn" is equal to True then isDateON is also True
        let refreshedDate = DatePairs(startDate: startDate.date, endDate: endDate.date, isDateFeatureOn: true)
        dateDelegate?.dateRefreshed(newDates: refreshedDate)
        dismiss(animated: true)
    }
  
    @IBAction func removeDateButton(_ sender: Any) {
        let refreshedDate = DatePairs(startDate: nil, endDate: nil, isDateFeatureOn: false)
        dateDelegate?.dateRefreshed(newDates: refreshedDate)
        dismiss(animated: true)
    }
}
