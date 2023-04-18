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
    
    private var navigationBar: UINavigationBar!
    private var customNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        lineChart.dataEntries = curPointEntry
        lineChart.isCurved = false
    }
    
    func setNavigationBar() {
            let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
            navigationBar.backgroundColor = .darkGray
            view.addSubview(navigationBar)
            customNavigationItem = UINavigationItem()
            customNavigationItem.title = "Line Chart"
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
