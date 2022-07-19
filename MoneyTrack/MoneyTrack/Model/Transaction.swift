//
//  Transaction.swift
//  MoneyTrack
//
//  Created by Brian Rosales on 6/14/22.
//

import Foundation
import CoreData

//Formats it for Core Data
struct Transaction {
    var name: String
    var date: Date
    var amount: Float
    var isIncome: Bool = true
}
