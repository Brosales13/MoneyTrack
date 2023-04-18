//
//  MoneyViewController.swift
//  MoneyTrack
//
//  Created by Brian Rosales on 6/15/22.
//

import Foundation
import UIKit

class MoneyViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var choiceButton: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    private var navigationBar: UINavigationBar!
    private var customNavigationItem: UINavigationItem!
    
    var delegate: MoneyDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        searchTextField.delegate = self
        nameTextField.delegate = self
        
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

//MARK: - UITextFieldDelegate (all about the search bar)
extension MoneyViewController: UITextFieldDelegate {
    
    @IBAction func saveButton (_sender: UIButton) {
        searchTextField.endEditing(true)
        if searchTextField.text != "" && nameTextField.text != "" {
            let moneyInfo = Transaction(name: nameTextField.text!, date: datePicker.date, amount: Float(searchTextField.text!)!, isIncome: choiceButton.selectedSegmentIndex == 0 ? true : false)
            
            delegate?.updateTransactions(newTransaction: moneyInfo)
            dismiss(animated: true)
        }
       

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)

        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Put Info"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // gonna be responsible to going back to home screen
    }
}
