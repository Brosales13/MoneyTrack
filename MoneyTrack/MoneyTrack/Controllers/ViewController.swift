//
//  ViewController.swift
//  MoneyTrack
//
//  Created by Brian Rosales on 6/11/22.
//

import UIKit
import CoreData

protocol MoneyDelegate {
    func updateTransactions(newTransaction: Transaction)
}
protocol DateDelegate {
    func dateRefreshed(newDates: DatePairs)
}

class ViewController: UIViewController{
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var expenseSumLabel: UILabel!
    @IBOutlet weak var incomeSumLabel: UILabel!
    @IBOutlet weak var segmentButton: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateOptions: UIButton!
    @IBOutlet weak var graphButton: UIButton!
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    var predicate: NSPredicate?
    var newDates: DatePairs = DatePairs(startDate: nil, endDate: nil, isDateFeatureOn: false)
    var isIncome: Bool = true
    var totalSum: Float = 0.0
    var incomeSum: Float = 0.0
    var expenseSum: Float = 0.0
    var rangeTitle: String = ""
    //checks if the date feature is on
    var isDateOn: Bool = false

    
    //Responsible for holding all info from coreData
    var money: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
     
        fetchInfo()
        updateUITotals()
    }
    
    @IBAction func timeLineButton(_ sender: UIButton) {
    }
    
    //responsible for seeing what data to retrieve and then recalling tableview function
    @IBAction func segmentChange(_ sender: Any) {
        let currSegment = segmentButton.selectedSegmentIndex
        print("segment change")
        
        if isDateOn == true {
            let predicate1 = NSPredicate(format: "date >= %@", newDates.startDate! as NSDate)
            let predicate2 = NSPredicate(format: "date <= %@", newDates.endDate! as NSDate)
            let predicate3 = NSPredicate(format: "isIncome = %@", NSNumber(value: true))
            let predicate4 = NSPredicate(format: "isIncome = %@", NSNumber(value: false))
            
            if currSegment == 0 {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
            } else if currSegment == 1 {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            } else if currSegment == 2 {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate4])
            }
            fetchInfo()
            updateUITotals()
            return
            
        }
        
        //if isDateon = false
        if currSegment == 0 {
            predicate = NSPredicate(format: "isIncome = %@", NSNumber(value: true))
        } else if currSegment ==  2 {
            predicate = NSPredicate(format: "isIncome = %@", NSNumber(value: false))
        }
        else if currSegment == 1 {
            predicate = nil
        }
        fetchInfo()
        updateUITotals()
    }
   
    func updateUITotals() {
        DispatchQueue.main.async { [self] in

            totalSum = 0.0
            incomeSum = 0.0
            expenseSum = 0.0
            rangeTitle = ""
           
            for cur in money {
                let isIncome = cur.value(forKey: "isIncome") as! Bool
                let amount =  cur.value(forKey: "amount") as! Float
                
                if isIncome == true {
                    self.totalSum += amount
                    self.incomeSum += amount
                } else {
                    self.totalSum -= amount
                    self.expenseSum += amount
                }
                rangeTitle = "All Data"
            }
            totalSumLabel.text = "$\(totalSum)"
            incomeSumLabel.text = "$\(incomeSum)"
            expenseSumLabel.text = "$\(expenseSum)"
            
            if isDateOn == true {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy"
                let formattedStartDate = dateFormatter.string(from: newDates.startDate!)
                let formattedEndDate = dateFormatter.string(from: newDates.endDate!)
                rangeTitle = "\(formattedStartDate) - \(formattedEndDate)"
            }
            
            dateRangeLabel.text = rangeTitle
        }
       
    }
    
    func fetchInfo() {
        DispatchQueue.main.async {
            self.context.performAndWait {
                // Setup a fetchRequest
                let fetchRequest = DataInfo.fetchRequest()
                
                //Assign Predicate
                fetchRequest.predicate = self.predicate
                
                //Assign sort descriptor
                let sortDate = NSSortDescriptor(key: #keyPath(DataInfo.date), ascending: false)
                fetchRequest.sortDescriptors = [sortDate]
                
                //Update money array with the new data
                self.money = try! self.context.fetch(fetchRequest)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func moneyButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addingMoney", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addingMoney"{
            let destinationVC = segue.destination as! MoneyViewController
            //current viewcontroller incharge of this
            destinationVC.delegate = self
            
        } else if segue.identifier == "addingDate" {
            let destinationVC = segue.destination as! DateViewController
            destinationVC.dateDelegate = self
            
        } else if segue.identifier ==  "graphingData" {
            var curPointEntry: [PointEntry] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            for currItem in money{
                let holdDate = currItem.value(forKey: "date") as! Date
                curPointEntry.append(PointEntry(value: currItem.value(forKey: "amount") as! Float , label: dateFormatter.string(from: holdDate)))
            }
            
            print("ayy")
            let destinationVC = segue.destination as! LineChartViewController
            destinationVC.curPointEntry = curPointEntry
        }
    }
    
    //updates the Top labels when a cell is deleted (Dont delete yet)
    func balanceUpdate(currIsIncome: Bool, currAmount: Float) {
        
        if currIsIncome == true {
            self.totalSum = self.totalSum - currAmount
            self.incomeSum = self.incomeSum - currAmount
            totalSumLabel.text = "$\(self.totalSum)"
            incomeSumLabel.text = "$\(self.incomeSum)"
            expenseSumLabel.text = "$\(self.expenseSum)"
        } else {
            self.totalSum = self.totalSum + currAmount
            self.expenseSum = self.expenseSum - currAmount
            totalSumLabel.text = "$\(self.totalSum)"
            expenseSumLabel.text = "$\(self.expenseSum)"
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let objectToRemove = self.money[indexPath.row]
            self.context.delete(objectToRemove)
            money.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            
            let curIsIscome = objectToRemove.value(forKey: "isIncome") as! Bool
            let currAmount = objectToRemove.value(forKey: "amount") as! Float
            
            do {
                try self.context.save()
                balanceUpdate(currIsIncome: curIsIscome, currAmount: currAmount)
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return money.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TableViewCell is swift file that organizes the labels
        let cell = tableView.dequeueReusableCell(withIdentifier: "redoCell") as! TableViewCell
       
        let currItem = money[indexPath.row]
        var name = currItem.value(forKey: "name") as! String
        cell.nameLabel.text = name
        
        var amount = currItem.value(forKey: "amount") as! Float
        var isIncome = currItem.value(forKey: "isIncome") as! Bool
        let dollarSign = isIncome ? "$" : "-$"
        let dollarFormat = dollarSign + String(format: "%.2f", amount)
        cell.priceLabel.textColor = isIncome ? UIColor(red: 28/255, green: 171/255, blue: 0, alpha: 1) : .red
        cell.priceLabel.text = dollarFormat
        
        var date = currItem.value(forKey: "date") as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let formattedDate = dateFormatter.string(from: date)
        cell.dateLabel.text = formattedDate
        
        return cell
    }
}

extension ViewController: MoneyDelegate {
    func updateTransactions(newTransaction: Transaction) {
        context.performAndWait {
            let newStoredData = DataInfo(context: context)
            newStoredData.name = newTransaction.name
            newStoredData.isIncome = newTransaction.isIncome
            newStoredData.date = newTransaction.date
            newStoredData.amount = newTransaction.amount
            
            try! context.save()
        }
        
        fetchInfo()
    }
}

extension ViewController: DateDelegate {
    func dateRefreshed(newDates: DatePairs) {
        isDateOn = newDates.isDateFeatureOn
        self.newDates = newDates
        segmentButton.selectedSegmentIndex = 1
        segmentChange(self)

    }
}
