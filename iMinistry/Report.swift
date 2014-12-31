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

    @NSManaged var hours: NSNumber?
    @NSManaged var books: NSNumber?
    @NSManaged var magazines: NSNumber?

}
