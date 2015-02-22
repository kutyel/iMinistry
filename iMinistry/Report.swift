//
//  Report.swift
//  iMinistry
//
//  Created by Flavio Corpa on 28/12/14.
//  Copyright (c) 2014 Flavio Corpa. All rights reserved.
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
}
