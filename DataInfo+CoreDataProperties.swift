//
//  DataInfo+CoreDataProperties.swift
//  MoneyTrack
//
//  Created by Brian Rosales on 7/2/22.
//
//

import Foundation
import CoreData


extension DataInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataInfo> {
        return NSFetchRequest<DataInfo>(entityName: "DataInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Float
    @NSManaged public var date: Date?
    @NSManaged public var isIncome: Bool

}

extension DataInfo : Identifiable {

}
