//
//  LineChartViewController.swift
//  MoneyTrack
//
//  Created by Brian Rosales on 7/18/22.
//

import UIKit

class LineChartViewController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChart!
    var curPointEntry: [PointEntry]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChart.dataEntries = curPointEntry
        lineChart.isCurved = false
    }
}
