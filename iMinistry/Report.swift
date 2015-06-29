//
//  Report.swift
//  iMinistry
//
//  Created by Flavio Corpa on 28/12/14.
//  Copyright © 2014 Flavio Corpa. All rights reserved.
//

import Foundation
import CoreData

class Report: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var hours: NSDate?
    @NSManaged var books: NSNumber?
    @NSManaged var brochures: NSNumber?
    @NSManaged var magazines: NSNumber?
    @NSManaged var bible_studies: NSNumber?
    @NSManaged var return_visits: NSNumber?
    
    func time () -> NSDateComponents? {
        let cal = NSCalendar.currentCalendar()
        let start = cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: self.hours!, options: [])
        return cal.components([.Hour, .Minute], fromDate: start!, toDate: self.hours!, options: [])
    }
    
    func month () -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: self.date).month
    }
    
    func week () -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: self.date).weekOfYear
    }
}
