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
    
    private var navigationBar: UINavigationBar!
    private var customNavigationItem: UINavigationItem!
    
    var dateDelegate: DateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
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
    
    func setNavigationBar() {
            let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 38))
            navigationBar.backgroundColor = .darkGray
            view.addSubview(navigationBar)
            customNavigationItem = UINavigationItem()
            customNavigationItem.title = ""
            let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(done))
            customNavigationItem.leftBarButtonItem = leftBarButton
            navigationBar.items = [customNavigationItem]
            self.view.addSubview(navigationBar)
            
        }
        
        @objc func done() {
            dismiss(animated: true, completion: nil)
            print("done")
        }
}
